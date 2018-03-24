package db;

import model.Genre;
import model.Movie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class GensInMovDB {

    private Connection connection = DBConnector.getConnection();
    private MoviesDB mDAO = new MoviesDB();
    private GenresDB gDAO = new GenresDB();

    public void insertGenInMv(Map<Movie, Set<Genre>> genreInMovie) throws SQLException {

        System.out.println("Updating the genres in movie...");
        connection.setAutoCommit(false);

        String sql = "insert into genres_in_movies (genreId, movieId) values(?,?);";
        PreparedStatement prepstmt = connection.prepareStatement(sql);

        if (!genreInMovie.isEmpty()){
            for (Movie m : genreInMovie.keySet()){
                String movieid = mDAO.getIdByTitle(m.getTitle());

                for (Genre g : genreInMovie.get(m)){
                    int genreid = gDAO.getIdByName(g.getName());

                    if (movieid != "" && genreid != -1){
                        prepstmt.setInt(1, genreid);
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
