package db;

import model.Star;

import java.sql.*;
import java.util.Set;

public class StarsDB {

    private Connection connection = DBConnector.getConnection();

    public boolean insertStars(Set<Star> starsList) throws SQLException {

        boolean flag = false;
        PreparedStatement prepstmt = null;


        String maxId = "SELECT CONCAT('nm', CAST(SUBSTRING((select max(id) from stars), 3) AS UNSIGNED) + 1)";
        Statement stmtId = connection.createStatement();
        ResultSet rsId = stmtId.executeQuery(maxId);
        String id = "";

        //String sql1 = "{call add_movie(?,?,?)}";

        if (rsId.next()) {
            id = rsId.getString(1);
            if (id == null) {
                id = "nm00000000";
            }
        }

        stmtId.close();
        rsId.close();

        String sql = "replace into stars (id, name, birthYear) values(?, ?, ?);";
        // create a Statement from the connection
        prepstmt = connection.prepareStatement(sql);

        int addCount = 0;
        int updateCount = 0;

        if (starsList != null && !starsList.isEmpty()){
            for (Star s: starsList){

                int year = s.getDob();
                String name = s.getName().replaceAll("[^a-zA-Z ]", "");

                if (name == null || name.length() == 0) {
                    continue;
                }

//                String sqlId = "set max_movie_id = (select max(id) from movies);" +
//                        "  set max_movie_id = cast(SUBSTRING(max_movie_id,3) as unsigned);" +
//                        "  set max_movie_id = max_movie_id + 1;";

                String judge = "select * from stars where name = '" + name + "' and birthYear = '" + year + "'";
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(judge);

                if (rs.next()) {

                    rs.close();
                    stmt.close();
                    updateCount++;
                    continue;

                } else {
                    rs.close();
                    stmt.close();

                    prepstmt.setString(1, id);
                    prepstmt.setString(2, name);
                    prepstmt.setInt(3, year);

                    prepstmt.addBatch();

                    id = "nm" + (Integer.valueOf(id.substring(2, id.length())) + 1);
                    addCount++;
                }


            }
            prepstmt.executeBatch();
            flag = true;

        }

        System.out.println("Add " + addCount + " new stars successfully!");
        System.out.println("Update " + updateCount + " stars successfully!");

        prepstmt.close();

        return flag;
    }

    public String getIdByStarName(String name) throws SQLException{
        //Movies m = new Movies();
        String id = "";
        String sql = "select id from stars where name = ?";
        PreparedStatement prepstmt = connection.prepareStatement(sql);
        prepstmt.setString(1, name);

        ResultSet rs = prepstmt.executeQuery();

        while(rs.next()){
            id = rs.getString(1);
        }

        prepstmt.close();
        rs.close();

        return id;
    }
}
