package nfpbreastfeedinglambdas.nfpbreastfeedingsurveys;

import com.amazonaws.services.dynamodbv2.document.Item;

public class OnboardingSurvey implements BreastFeedingSurveys {

	private String userName;
	private String date;
	private String type;
	
	private String biologicalSex;
	private String biologicalInfant;
	private String singletonBirth;
	private String babyFullTerm;
	private String participantAgeInRange;
	private String momHealth;
	private String breastSurgery;
	private String infantAgeInRange;
	private String clearBlueMonitor;
	private String canReadEnglish;
	private String participantBirthDate;
	private String babyBirthDate;
	private String babyFeedOnDemand;
	private String breastPumpInfo;
	private String ethnicity;
	private String religion;
	private String levelOfEducation;
	private String relationshipStatus;
	private String marriedLength;
	private String howManyTimesPregnant;
	private String howManyBiologicalChildren;
	private String howManyChildrenBreastFed;
	private String howLongInPastBreastFed;

	public Item getDynamoDBItem() {
		return new Item().with("userName", userName)
				.with("date", date)
				.with("type", type)
				.with("biologicalSex", biologicalSex)
				.with("biologialInfant", biologicalInfant)
				.with("singletonBirth", singletonBirth)
				.with("babyFullTerm", babyFullTerm)
				.with("particpantAgeInRange", participantAgeInRange)
				.with("momHealth", momHealth)
				.with("breastSurgery", breastSurgery)
				.with("infantAgeInRange", infantAgeInRange)
				.with("ownClearBlueMonitor", clearBlueMonitor)
				.with("canReadEnglish", canReadEnglish)
				.with("participantBirthDate", participantBirthDate)
				.with("babyBirthDate", babyBirthDate)
				.with("babyFeedOnDemand", babyFeedOnDemand)
				.with("breastPumpInfo", breastPumpInfo)
				.with("ethnicity", ethnicity)
				.with("religion", religion)
				.with("levelOfEducation", levelOfEducation)
				.with("relationshipStatus", relationshipStatus)
				.with("marriedLength", marriedLength)
				.with("howManyTimesPregnant", howManyTimesPregnant)
				.with("howManyBiologicalChildren", howManyBiologicalChildren)
				.with("howManyChildrenBreastFed", howManyChildrenBreastFed)
				.with("howLongInPastBreastFed", howLongInPastBreastFed);
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
	
	public void setBiologicalSex(String biologicalSex) {
		this.biologicalSex = biologicalSex;
	}
	
	public String getBiologicalSex() {
		return biologicalSex;
	}
	
	public void setBiologicalInfant(String biologicalInfant) {
		this.biologicalInfant = biologicalInfant;
	}
	
	public String getBiologicalInfant() {
		return biologicalInfant;
	}
	
	public void setSingletonBirth(String singletonBirth) {
		this.singletonBirth = singletonBirth;
	}
	
	public String getSingletonBirth() {
		return singletonBirth;
	}
	
	public void setBabyFullTerm(String babyFullTerm) {
		this.babyFullTerm = babyFullTerm;
	}
	
	public String getBabyBornFullTerm() {
		return babyFullTerm;
	}
	
	public String getParticipantAgeInRange() {
		return participantAgeInRange;
	}
	
	public void setParticipantAgeInRange(String participantAgeInRange) {
		this.participantAgeInRange = participantAgeInRange;
	}
	
	public String getMomHealth() {
		return momHealth;
	}
	
	public void setMomHealth(String momHealth) {
		this.momHealth = momHealth;
	}
	
	public String getBreastSurgery() {
		return breastSurgery;
	}
	
	public void setBreastSurgery(String breastSurgery) {
		this.breastSurgery = breastSurgery;
	}
	
	public String getInfantAgeInRange() {
		return infantAgeInRange;
	}
	
	public void setInfantAgeInRange(String infantAgeInRange) {
		this.infantAgeInRange = infantAgeInRange;
	}
	
	public String getClearBlueMonitor() {
		return clearBlueMonitor;
	}
	
	public void setClearBlueMonitor(String clearBlueMonitor) {
		this.clearBlueMonitor = clearBlueMonitor;
	}
	
	public String getCanReadEnglish() {
		return canReadEnglish;
	}
	
	public void setCanReadEnglish(String canReadEnglish) {
		this.canReadEnglish = canReadEnglish;
	}
	
	public String getParticipantBirthDate() {
		return participantBirthDate;
	}
	
	public void setParticipantBirthDate(String participantBirthDate) {
		this.participantBirthDate = participantBirthDate;
	}
	
	public String getBabyFeedOnDemand() {
		return babyFeedOnDemand;
	}
	
	public void setBabyFeedOnDemand(String babyFeedOnDemand) {
		this.babyFeedOnDemand = babyFeedOnDemand;
	}
	
	public String getBabyBirthDate() {
		return babyBirthDate;
	}
	
	public void setBabyBirthDate(String babyBirthDate) {
		this.babyBirthDate = babyBirthDate;
	}
	
	public String getBreastPumpInfo() {
		return breastPumpInfo;
	}
	
	public void setBreastPumpInfo(String breastPumpInfo) {
		this.breastPumpInfo = breastPumpInfo;
	}
	
	public String getEthnicity() {
		return ethnicity;
	}
	
	public void setEthnicity(String ethnicity) {
		this.ethnicity = ethnicity;
	}
	
	public String getReligion() {
		return religion;
	}
	
	public void setReligion(String religion) {
		this.religion = religion;
	}
	
	public String getLevelOfEducation() {
		return levelOfEducation;
	}
	
	public void setLevelOfEducation(String levelOfEducation) {
		this.levelOfEducation = levelOfEducation;
	}
	
	public String getRelationshipStatus() {
		return relationshipStatus;
	}
	
	public void setRelationshipStatus(String relationshipStatus) {
		this.relationshipStatus = relationshipStatus;
	}
	
	public String getMarriedLength() {
		return marriedLength;
	}
	
	public void setMarriedLength(String marriedLength) {
		this.marriedLength = marriedLength;
	}
	
	public String getHowManyBiologicalChildren() {
		return howManyBiologicalChildren;
	}
	
	public void setHowManyBiologicalChildren(String howManyBiologicalChildren) {
		this.howManyBiologicalChildren = howManyBiologicalChildren;
	}
	
	public String getHowManyTimesPregnant() {
		return howManyTimesPregnant;
	}
	
	public void setHowManyTimesPregnant(String howManyTimesPregant) {
		this.howManyTimesPregnant = howManyTimesPregant;
	}
	
	public String getHowManyChildrenBreastFed() {
		return howManyChildrenBreastFed;
	}
	
	public void setHowManyChildrenBreastFed(String howManyChildrenBreastFed) {
		this.howManyChildrenBreastFed = howManyChildrenBreastFed;
	}
	
	public String getHowLongInPastBreastFed() {
		return howLongInPastBreastFed;
	}
	
	public void setHowLongInPastBreastFed(String howLongInPastBreastFed) {
		this.howLongInPastBreastFed = howLongInPastBreastFed;
	}
	
	@Override
	public String toString() {
		return "User Name: " + userName +
				" date: " + date +
				" surveyType: " + type +
				" biologicalSex: " + biologicalSex +
				" biologicalInfant: " + biologicalInfant +
				" singletonBirth: " + singletonBirth +
				" babyFullTerm: " + babyFullTerm +
				" participantAgeInRange: " + participantAgeInRange +
				" momHealth: " + momHealth +
				" breastSurgery: " + breastSurgery +
				" infantAgeInRange: " + infantAgeInRange +
				" clearBlueMonitor: " + clearBlueMonitor +
				" canReadEnglish: " + canReadEnglish +
				" participantBirthDate: " + participantBirthDate +
				" babysBirthDate: " + babyBirthDate +
				" babyFeedOnDemand: " + babyFeedOnDemand +
				" breastPumpInfo: " + breastPumpInfo +
				" ethnicity: " + ethnicity +
				" religion: " + religion +
				" levelOfEducation: " + levelOfEducation +
				" relationshipStatus: " + relationshipStatus + 
				" marriedLength: " + marriedLength +
				" howManyTimesPregant: " + howManyTimesPregnant +
				" howManyBiologicalChildren: " + howManyBiologicalChildren +
				" howManyChildrenBreastFed: " + howManyChildrenBreastFed +
				" howLongInPastBreastFed: " + howLongInPastBreastFed;
	}
}
