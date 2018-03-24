package db;

import model.Movie;
import model.Star;

import java.sql.*;
import java.util.Map;
import java.util.Set;

public class StasInMovDB {

    private Connection connection = DBConnector.getConnection();
    private MoviesDB mDAO = new MoviesDB();
    private StarsDB sDAO = new StarsDB();

    public void insertStaInMv(Map<Movie, Set<Star>> starInMovie) throws SQLException {

        System.out.println("Updating the stars in movie...");
        connection.setAutoCommit(false);

        String sql = "insert into stars_in_movies (starId, movieId) values(?,?);";
        PreparedStatement prepstmt = connection.prepareStatement(sql);

        if (!starInMovie.isEmpty()){
            for (Movie m : starInMovie.keySet()){
                String movieid = mDAO.getIdByTitle(m.getTitle());

                for (Star s : starInMovie.get(m)){

                    String starid = sDAO.getIdByStarName(s.getName());

                    if (movieid != "" && starid != ""){
                        prepstmt.setString(1, starid);
                        prepstmt.setString(2, movieid);
                        prepstmt.addBatch();
                    }

                }
            }

            prepstmt.executeBatch();

        }
        connection.commit();
        prepstmt.close();

    }
}
