package db;

import model.Movie;

import java.sql.*;
import java.util.Set;

public class MoviesDB {

    private Connection connection = DBConnector.getConnection();

    public boolean insertMovies(Set<Movie> movieList) throws SQLException {

        boolean flag = false;
        PreparedStatement prepstmt = null;
        int addCount = 0;
        int updateCount = 0;

        String maxId = "SELECT CONCAT('tt', CAST(SUBSTRING((select max(id) from movies), 3) AS UNSIGNED) + 1)";
        Statement stmtId = connection.createStatement();
        ResultSet rsId = stmtId.executeQuery(maxId);
        String id = "";

        if (rsId.next()) {
            id = rsId.getString(1);
            if (id == null) {
                id = "tt00000000";
            }
        }

        stmtId.close();
        rsId.close();

        String sql = "replace into movies (id, title, year, director) values(?, ?, ?, ?);";
        // create a Statement from the connection
        prepstmt = connection.prepareStatement(sql);


        if (movieList != null && !movieList.isEmpty()){
            for (Movie m: movieList){

                String title = m.getTitle();
                int year = m.getYear();
                String director = m.getDirector();
                if (year == -1 || title == "") continue;

                String judge = "select * from movies where title = '" + title + "' and year = '" + year + "'";
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(judge);

                if (rs.next()) {
                    rs.close();
                    stmt.close();
                    updateCount++;
                    continue;
                }

                prepstmt.setString(1, id);
                prepstmt.setString(2, title);
                prepstmt.setInt(3, year);
                prepstmt.setString(4, director);

                prepstmt.addBatch();
                addCount++;
                id = "tt" + (Integer.valueOf(id.substring(2, id.length())) + 1);

            }

            flag = true;
            prepstmt.executeBatch();

        }

        System.out.println("Add " + addCount + " new movies successfully!");
        System.out.println("Update " + updateCount + " movies successfully!");
        prepstmt.close();

        return flag;
    }

    public String getIdByTitle(String title) throws SQLException{
        //Movies m = new Movies();
        String id = "";
        String sql = "select id from movies where title = ?";
        PreparedStatement prepstmt = connection.prepareStatement(sql);
        prepstmt.setString(1, title);
        ResultSet rs = prepstmt.executeQuery();

        while(rs.next()){
            id = rs.getString(1);
        }

        prepstmt.close();
        rs.close();
        return id;
    }
}
