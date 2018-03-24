package model;

public class Movie {
	private int id;
	private String title;
	private String director;
	private int year;
	
	public void setId(int id) {
		this.id = id;
	}
	
	public int getId() {
		return id;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setDirector(String director) {
		this.director = director;
	}
	
	public String getDirector() {
		return director;
	}
	
	public void setYear(int year) {
		this.year = year;
	}
	
	public int getYear() {
		return year;
	}

	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return this.getTitle() == null ? 0 : this.getTitle().hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		if(this == obj)
		{
			return true;
		}
		if(obj instanceof Movie)
		{
		    if (this.getTitle() == null) {
		        return true;
            }

			Movie i = (Movie)obj;
			if( this.getTitle().equals(i.getTitle()) )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}

}

