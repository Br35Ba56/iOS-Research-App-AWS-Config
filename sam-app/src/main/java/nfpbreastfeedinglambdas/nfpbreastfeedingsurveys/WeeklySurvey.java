package nfpbreastfeedinglambdas.nfpbreastfeedingsurveys;

import com.amazonaws.services.dynamodbv2.document.Item;

public class WeeklySurvey implements BreastFeedingSurveys {

	private String userName;
	private String date;
	private String type;
	private String areYouPregnant;
	private String usedAnyContraceptives;
	private String recentlyDiagnosed;
	private String stillBreastfeeding;
	private String didMenstruateThisWeek;
	
	public Item getDynamoDBItem() {
		return new Item().with("userName", userName)
				.with("date", date)
				.with("type", type)
				.with("areYouPregnant", areYouPregnant)
				.with("didMenstruateThisWeek", didMenstruateThisWeek)
				.with("usedAnyContraceptives", usedAnyContraceptives)
				.with("recentlyDiagnosed", recentlyDiagnosed)
				.with("stillBreastfeeding", stillBreastfeeding);
	}
	
	public void setUserName(String userName) {
		this.userName = String.valueOf(userName.hashCode());;	
	}
	
	public String getUserName() {
		return userName;
	}
	
	public void setDate(String date) {
		this.date = date;
	}
	
	public String getDate() {
		return date;
	}
	
	public void setType(String type) {
		this.type = type;		
	}
	
	public String getType() {
		return type;
	}
	
	public String getAreYouPregnant() {
		return areYouPregnant;
	}
	
	public void setAreYouPregnant(String areYouPregnant) {
		this.areYouPregnant = areYouPregnant;
	}
	
	public String getUsedAnyContraceptives() {
		return usedAnyContraceptives;
	}
	
	public void setUsedAnyContraceptives(String usedAnyContraceptives) {
		this.usedAnyContraceptives = usedAnyContraceptives;
	}
	
	public String getRecentlyDiagnosed() {
		return recentlyDiagnosed;
	}
	
	public void setRecentlyDiagnosed(String recentlyDiagnosed) {
		this.recentlyDiagnosed = recentlyDiagnosed;
	}
	
	public String getStillBreastfeeding() {
		return stillBreastfeeding;
	}
	
	public void setStillBreastfeeding(String stillBreastfeeding) {
		this.stillBreastfeeding = stillBreastfeeding;
	}
	
	public String getDidMenstruateThisWeek() {
		return didMenstruateThisWeek;
	}
	
	public void setDidMenstruateThisWeek(String didMenstruateThisWeek) {
		this.didMenstruateThisWeek = didMenstruateThisWeek;
	}
	
	@Override
	public String toString() {
		return "User Name: " + userName + 
				" Date: " + date + 
				" Survey Type: " + type + 
				" areYouPregnant: " + areYouPregnant + 
				" usedAnyContraceptives: " + usedAnyContraceptives + 
				" recentlDiagnosed: " + recentlyDiagnosed + 
				" stillBreastfeeding: "+ stillBreastfeeding +
				" didMenstruateThisWeek: " + didMenstruateThisWeek;	
	}
}