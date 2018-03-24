package model;

import java.util.Date;

public class Star {
	
	private int id;
	private String name;
	private int dob;
	
	public void setId(int id) {
		this.id = id;
	}
	
	public int getId() {
		return id;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public int getDob() {
		return dob;
	}

    public void setDob(String dob) {
	    try {
            this.dob = Integer.valueOf(dob.trim());
        } catch (Exception e) {

        }

    }

	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return this.getName().hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		if(this==obj){
			return true;
		}

		if(obj instanceof Star){
			Star s = (Star)obj;
			if(this.getName().equals(s.getName()))
			{
				return true;
			}
			else
			{
				return false;
			}
		}else{
			return false;
		}
	}


}

