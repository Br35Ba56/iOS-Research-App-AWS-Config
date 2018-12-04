package nfpbreastfeedinglambdas.nfpbreastfeedingsurveys;

import com.amazonaws.services.dynamodbv2.document.Item;

public class DailySurvey implements BreastFeedingSurveys{
	private String userName;
	private String date;
	private String type;
	private String experienceBleeding;
	private String clearBlueMonitor;
	private String menstruation;
	private String progesterone;
	private String numOfTimesBabyFormulaFed;
	private String numOfTimesBabyExpressFed;
	private String numOfTimesBabyBreastFed;
		
	public Item getDynamoDBItem() {
		return new Item().with("userName", userName)
				.with("date", date)
				.with("type", type)
				.with("experienceBleeding", experienceBleeding)
				.with("clearBlueMonitor", clearBlueMonitor)
				.with("menstruation", menstruation)
				.with("progesterone", progesterone)
				.with("numOfTimesBabyFormulaFed", numOfTimesBabyFormulaFed)
				.with("numOfTimesBabyExpressFed", numOfTimesBabyExpressFed)
				.with("numOfTimesBabyBreastFed", numOfTimesBabyBreastFed);
	}
	
	public void setUserName(String userName) {
		this.userName = String.valueOf(userName.hashCode());
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

	public String getExperienceBleeding() {
		return experienceBleeding;
	}

	public void setExperienceBleeding(String experienceBleeding) {
		this.experienceBleeding = experienceBleeding;
	}

	public String getClearBlueMonitor() {
		return clearBlueMonitor;
	}

	public void setClearBlueMonitor(String clearBlueMonitor) {
		this.clearBlueMonitor = clearBlueMonitor;
	}

	public String getNumOfTimesBabyFormulaFed() {
		return numOfTimesBabyFormulaFed;
	}

	public void setNumOfTimesBabyFormulaFed(String numOfTimesBabyFormulaFed) {
		this.numOfTimesBabyFormulaFed = numOfTimesBabyFormulaFed;
	}

	public String getNumOfTimesBabyExpressFed() {
		return numOfTimesBabyExpressFed;
	}

	public void setNumOfTimesBabyExpressFed(String numOfTimesBabyExpressFed) {
		this.numOfTimesBabyExpressFed = numOfTimesBabyExpressFed;
	}

	public String getNumOfTimesBabyBreastFed() {
		return numOfTimesBabyBreastFed;
	}

	public void setNumOfTimesBabyBreastFed(String numOfTimesBabyBreastFed) {
		this.numOfTimesBabyBreastFed = numOfTimesBabyBreastFed;
	}

	public void setProgesterone(String progesterone) {
		this.progesterone = progesterone;
	}

	public String getProgesterone() {
		return progesterone;
	}

	public String getMenstruation() {
		return menstruation;
	}

	public void setMenstruation(String menstruation) {
		this.menstruation = menstruation;
	}

	@Override
	public String toString() {
		return "User Name: " + userName +
				" Date: " + date + 
				" SurveyType: " + type + 
				" ExperienceBleeding: " + experienceBleeding + 
				" ClearBlueMonitor: " + clearBlueMonitor +
				" Progesterone: " + progesterone + 
				" Menstruation: " + menstruation + 
				" Formula: " + numOfTimesBabyFormulaFed + 
				" Express: " + numOfTimesBabyExpressFed + 
				" Breast: " + numOfTimesBabyBreastFed;
	}
}
