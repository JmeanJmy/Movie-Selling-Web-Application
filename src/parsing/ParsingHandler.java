package parsing;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import model.*;

import model.Genre;
import model.Movie;
import model.Star;

public class ParsingHandler extends DefaultHandler{
	Movie movie = null;
	Star star = null;
	Genre genre = null;
	
	Set<Movie> movies = new HashSet<>();
	Set<Star> stars = new HashSet<>();
	HashSet<Genre> genres = new HashSet<>();
	
	Map<Movie, Set<Genre>> genresInMovie = new HashMap<Movie, Set<Genre>>();
	Map<Movie, Set<Star>> starsInMovie = new HashMap<Movie, Set<Star>>();
	
	private HashSet<Genre> genresInMov;
	private HashSet<Star> starsInMov;
	
	String currentDirect = null;
	String tempVal;
	
	public Set<Movie> getMovieList() {
		return movies;
	}
	
	public Set<Star> getStarList() {
		return stars;
	}
	
	public Set<Genre> getGenreList() {
		return genres;
	}
	
	public Map<Movie, Set<Genre>> getGenresInMov() {
		return genresInMovie;
	}
	
	public Map<Movie, Set<Star>> getStarsInMov() {
		return starsInMovie;
	}
	
	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		super.startElement(uri, localName, qName, attributes);


		if (qName.equals("a") || qName.equals("actor")){
			star = new Star();
		
		}

		else if (qName.equals("film")){
			
			movie = new Movie();
			genresInMov = new HashSet<Genre>();
		
		}

		else if (qName.equals("cat")){
			
			genre = new Genre();
		
		}

		else if (qName.equals("filmc")){
			
			starsInMov = new HashSet<Star>();
			
		}

		else if (qName.equals("m")){
			movie = new Movie();
		}
	}
	
	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {

        if (qName.equals("stagename")) {
            star.setName(tempVal);
        }

        else if (qName.equals("dob")){
            star.setDob(tempVal);
        }

        else if (qName.equals("actor")){
            stars.add(star);
        }

		else if (qName.equals("dirname")) {
			currentDirect = tempVal;
		}
		
		else if (qName.equals("t")) {
			movie.setTitle(tempVal.replaceAll("[^a-zA-Z ]", ""));
		}

        else if (qName.equals("film")) {
            movie.setDirector(currentDirect);
            movies.add(movie);
            if (!genresInMovie.containsKey(movie)) {
                genresInMovie.put(movie, genresInMov);
            }
        }
		
		else if (qName.equals("year")) {
			try{
			    tempVal = tempVal.replaceAll("'", "");
                movie.setYear(Integer.valueOf(tempVal));
			}catch (NumberFormatException e){
				movie.setYear(-1);
			}
		}
		
		else if (qName.equals("cat")) {
			genre.setName(tempVal);
			genresInMov.add(genre);
			genres.add(genre);
		}

        else if (qName.equals("a")) {
            star.setName(tempVal);
            stars.add(star);
            starsInMov.add(star);
        }
		
		else if (qName.equals("filmc")) {
			if (!starsInMovie.containsKey(movie)) {
				starsInMovie.put(movie, starsInMov);
			}
		}
	}
	
    public void characters(char[] ch, int start, int length) throws SAXException {
        tempVal = new String(ch,start,length);
        this.tempVal = new String(ch, start, length);
        if (tempVal == null) {
            this.tempVal = "NULL";
        }
    }
	
	/**
	 * the start of the parsing
	 */
	@Override
	public void startDocument() throws SAXException {
		// TODO Auto-generated method stub
		super.startDocument();
		System.out.println("Starting SAX xml parsing...");
	}
	/**
	 * end of the parsing
	 */
	@Override
	public void endDocument() throws SAXException {
		// TODO Auto-generated method stub
		super.endDocument();
		System.out.println("Finished SAX xml parsing.");
	}
}
