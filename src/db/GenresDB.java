package db;

import model.Genre;
import model.Movie;

import java.sql.*;
import java.util.Set;

public class GenresDB {
    private Connection connection = DBConnector.getConnection();

    public boolean insertGenres(Set<Genre> genreList) throws SQLException {

        boolean flag = false;
        PreparedStatement prepstmt = null;

//        String maxId = "select max(id) from genres";
//        Statement stmtId = connection.createStatement();
//        ResultSet rsId = stmtId.executeQuery(maxId);
//        String id = "";
//        int gId = 0;
//        if (rsId.next()) {
//            id = rsId.getString(1);
//            if (id == null) {
//                gId = 0;
//            }else {
//                gId = Integer.valueOf(id);
//            }
//        }
//
//        stmtId.close();
//        rsId.close();

        String sql = "insert into genres (name) values(?);";

        prepstmt = connection.prepareStatement(sql);

        int addCount = 0;

        if (genreList != null && !genreList.isEmpty()){

            for (Genre g: genreList){

                String name = g.getName();
                if (name == null || name.length() == 0) continue;
                // create a Statement from the connection
                String judge = "select * from genres where name = '" + name + "'";
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(judge);

                if (rs.next()){
                    rs.close();
                    stmt.close();
                    continue;
                }else {
                    //gId++;
                    //prepstmt.setInt(1, gId);
                    prepstmt.setString(1, name);

                    prepstmt.addBatch();
                    addCount++;
                }



            }

            prepstmt.executeBatch();
            flag = true;

        }


        System.out.println("Add " + addCount + " new genres successfully!");
        prepstmt.close();

        return flag;
    }

    public int getIdByName(String name) throws SQLException{
        //Movies m = new Movies();
        int id = -1;
        String sql = "select id from genres where name = ?";
        PreparedStatement prepstmt = connection.prepareStatement(sql);
        prepstmt.setString(1, name);
        ResultSet rs = prepstmt.executeQuery();

        while(rs.next()){
            id = rs.getInt(1);
        }

        prepstmt.close();
        rs.close();
        return id;
    }
}
