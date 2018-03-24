package parsing;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import db.*;
import model.Genre;
import model.Movie;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import model.Star;



public class SaxParsing {
	
	private static ParsingHandler handler;
	
	public static void parse(String file) {
		try {
			//get paser factory instance
			SAXParser xmlparser = SAXParserFactory.newInstance().newSAXParser();
			handler = new ParsingHandler();
			
			//define the input source from xmlfile
			InputSource input = new InputSource(file);
			//encode iso-8859-1
			input.setEncoding("ISO-8859-1");
			
			xmlparser.parse(input, handler);
			
			
		} catch (ParserConfigurationException | SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		System.out.println("Parsing actors63.xml");
		SaxParsing parserMains = new SaxParsing();
        SaxParsing parserCasts = new SaxParsing();
        SaxParsing parserActors = new SaxParsing();

		/*parse actors63.xml*/

        parse("data/actors63.xml");
        Set<Star> starList = handler.getStarList();

        StarsDB sDB = new StarsDB();
        MoviesDB mDB = new MoviesDB();
        GenresDB gDB = new GenresDB();
        GensInMovDB gInMov = new GensInMovDB();
        StasInMovDB sInMov = new StasInMovDB();

        try {

			sDB.insertStars(starList);

		} catch (SQLException e) {
			System.err.println(e.getMessage());
		}

        System.out.println("Star size " + starList.size());




        /*parse mains243.xml*/
        System.out.println("Parsing mains243.xml");
		parse("data/mains243.xml");

		Set<Movie> movieList = handler.getMovieList();
		Set<Genre> genreList = handler.getGenreList();
        Map<Movie, Set<Genre>> genresInMov = handler.getGenresInMov();

        System.out.println("Movie size " + movieList.size());
        System.out.println("Genre size " + genreList.size());


        try {

            mDB.insertMovies(movieList);
            gDB.insertGenres(genreList);
            gInMov.insertGenInMv(genresInMov);

        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }

        System.out.println("Updating the genres in movies successfully!");


        /*parse casts124.xml */
        System.out.println("Parsing casts124.xml");
        parse("data/casts124.xml");
        Map<Movie, Set<Star>> starsInMov = handler.getStarsInMov();

        try {
            sInMov.insertStaInMv(starsInMov);
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            //e.printStackTrace();
            System.err.println(e.getMessage());
        }

        System.out.println("Updating the stars in movies successfully!");

	}
}
