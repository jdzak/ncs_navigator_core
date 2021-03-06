# -*- coding: utf-8 -*-

module PregnancyVisitOne
  def create_pregnancy_visit_1_survey_with_person_operational_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHI_P2_V2.0", :access_code => "ins-que-pregvisit1-int-ehpbhi-p2-v2-0_test")
    survey_section = Factory(:survey_section, :survey_id => survey.id)
    # First name
    q = Factory(:question, :reference_identifier => "R_FNAME", :data_export_identifier => "PREG_VISIT_1_2.R_FNAME", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "First name", :response_class => "string")
    a = Factory(:answer, :question_id => q.id, :text => "Refused", :response_class => "answer", :reference_identifier => "neg_1")
    a = Factory(:answer, :question_id => q.id, :text => "Don't know", :response_class => "answer", :reference_identifier => "neg_2")
    # Last name
    q = Factory(:question, :reference_identifier => "R_LNAME", :data_export_identifier => "PREG_VISIT_1_2.R_LNAME", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Last name", :response_class => "string")
    a = Factory(:answer, :question_id => q.id, :text => "Refused", :response_class => "answer", :reference_identifier => "neg_1")
    a = Factory(:answer, :question_id => q.id, :text => "Don't know", :response_class => "answer", :reference_identifier => "neg_2")
    # Date of Birth
    q = Factory(:question, :reference_identifier => "PERSON_DOB", :data_export_identifier => "PREG_VISIT_1_2.PERSON_DOB", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Date of Birth", :response_class => "date")
    a = Factory(:answer, :question_id => q.id, :text => "Refused", :response_class => "answer", :reference_identifier => "neg_1")
    a = Factory(:answer, :question_id => q.id, :text => "Don't know", :response_class => "answer", :reference_identifier => "neg_2")
    # Age Eligible
    q = Factory(:question, :reference_identifier => "AGE_ELIG", :data_export_identifier => "PREG_VISIT_1_2.AGE_ELIG", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Age Eligible", :response_class => "answer", :reference_identifier => "1")
    a = Factory(:answer, :question_id => q.id, :text => "Ineligible - too young", :response_class => "answer", :reference_identifier => "2")
    a = Factory(:answer, :question_id => q.id, :text => "Ineligible - too old", :response_class => "answer", :reference_identifier => "3")

    # Multiple Gestation
    q = Factory(:question, :reference_identifier => "MULTIPLE_GESTATION", :data_export_identifier => "PREG_VISIT_1_2.MULTIPLE_GESTATION", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Singleton", :response_class => "answer", :reference_identifier => "1")
    a = Factory(:answer, :question_id => q.id, :text => "Twins", :response_class => "answer", :reference_identifier => "2")
    a = Factory(:answer, :question_id => q.id, :text => "Triplets or higher", :response_class => "answer", :reference_identifier => "3")

    survey
  end

  def create_pregnancy_visit_1_survey_with_contact_operational_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHI_P2_V2.0", :access_code => "ins-que-pregvisit1-int-ehpbhi-p2-v2-0_test")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    # Contact 1 First Name
    q = Factory(:question, :reference_identifier => "CONTACT_FNAME_1", :data_export_identifier => "PREG_VISIT_1_2.CONTACT_FNAME_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "First Name", :response_class => "string")
    # Contact 1 Last Name
    q = Factory(:question, :reference_identifier => "CONTACT_LNAME_1", :data_export_identifier => "PREG_VISIT_1_2.CONTACT_LNAME_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Last Name", :response_class => "string")
    # Contact 1 Relationship Code
    q = Factory(:question, :reference_identifier => "CONTACT_RELATE_1", :data_export_identifier => "PREG_VISIT_1_2.CONTACT_RELATE_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "MOTHER/FATHER", :response_class => "answer", :reference_identifier => "1")
    a = Factory(:answer, :question_id => q.id, :text => "BROTHER/SISTER", :response_class => "answer", :reference_identifier => "2")
    a = Factory(:answer, :question_id => q.id, :text => "AUNT/UNCLE", :response_class => "answer", :reference_identifier => "3")
    a = Factory(:answer, :question_id => q.id, :text => "GRANDPARENT", :response_class => "answer", :reference_identifier => "4")
    a = Factory(:answer, :question_id => q.id, :text => "NEIGHBOR", :response_class => "answer", :reference_identifier => "5")
    a = Factory(:answer, :question_id => q.id, :text => "FRIEND", :response_class => "answer", :reference_identifier => "6")
    a = Factory(:answer, :question_id => q.id, :text => "OTHER", :response_class => "answer", :reference_identifier => "neg_5")
    # Contact 1 Relationship Other
    q = Factory(:question, :reference_identifier => "CONTACT_RELATE1_OTH", :data_export_identifier => "PREG_VISIT_1_2.CONTACT_RELATE1_OTH", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Specify", :response_class => "string")
    # Contact 1 Address One
    q = Factory(:question, :reference_identifier => "C_ADDR_1_1", :data_export_identifier => "PREG_VISIT_1_2.C_ADDR_1_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 1", :response_class => "string")
    # Contact 1 Address Two
    q = Factory(:question, :reference_identifier => "C_ADDR_2_1", :data_export_identifier => "PREG_VISIT_1_2.C_ADDR_2_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 2", :response_class => "string")
    # Contact 1 Unit
    q = Factory(:question, :reference_identifier => "C_UNIT_1", :data_export_identifier => "PREG_VISIT_1_2.C_UNIT_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Unit", :response_class => "string")
    # Contact 1 City
    q = Factory(:question, :reference_identifier => "C_CITY_1", :data_export_identifier => "PREG_VISIT_1_2.C_CITY_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "City", :response_class => "string")
    # Contact 1 State
    q = Factory(:question, :reference_identifier => "C_STATE_1", :data_export_identifier => "PREG_VISIT_1_2.C_STATE_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "IL", :response_class => "answer", :reference_identifier => "14")
    a = Factory(:answer, :question_id => q.id, :text => "MI", :response_class => "answer", :reference_identifier => "23")
    # Contact 1 Zip
    q = Factory(:question, :reference_identifier => "C_ZIPCODE_1", :data_export_identifier => "PREG_VISIT_1_2.C_ZIPCODE_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Zip", :response_class => "string")
    # Contact 1 plus 4
    q = Factory(:question, :reference_identifier => "C_ZIP4_1", :data_export_identifier => "PREG_VISIT_1_2.C_ZIP4_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "plus 4", :response_class => "string")
    # Contact 1 phone
    q = Factory(:question, :reference_identifier => "CONTACT_PHONE_1", :data_export_identifier => "PREG_VISIT_1_2.CONTACT_PHONE_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Phone Number", :response_class => "string")

    # Contact 2 First Name
    q = Factory(:question, :reference_identifier => "CONTACT_FNAME_2", :data_export_identifier => "PREG_VISIT_1_2.CONTACT_FNAME_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "First Name", :response_class => "string")
    # Contact 2 Last Name
    q = Factory(:question, :reference_identifier => "CONTACT_LNAME_2", :data_export_identifier => "PREG_VISIT_1_2.CONTACT_LNAME_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Last Name", :response_class => "string")
    # Contact 2 Relationship Code
    q = Factory(:question, :reference_identifier => "CONTACT_RELATE_2", :data_export_identifier => "PREG_VISIT_1_2.CONTACT_RELATE_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "MOTHER/FATHER", :response_class => "answer", :reference_identifier => "1")
    a = Factory(:answer, :question_id => q.id, :text => "BROTHER/SISTER", :response_class => "answer", :reference_identifier => "2")
    a = Factory(:answer, :question_id => q.id, :text => "AUNT/UNCLE", :response_class => "answer", :reference_identifier => "3")
    a = Factory(:answer, :question_id => q.id, :text => "GRANDPARENT", :response_class => "answer", :reference_identifier => "4")
    a = Factory(:answer, :question_id => q.id, :text => "NEIGHBOR", :response_class => "answer", :reference_identifier => "5")
    a = Factory(:answer, :question_id => q.id, :text => "FRIEND", :response_class => "answer", :reference_identifier => "6")
    a = Factory(:answer, :question_id => q.id, :text => "OTHER", :response_class => "answer", :reference_identifier => "neg_5")
    # Contact 2 Relationship Other
    q = Factory(:question, :reference_identifier => "CONTACT_RELATE2_OTH", :data_export_identifier => "PREG_VISIT_1_2.CONTACT_RELATE2_OTH", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Specify", :response_class => "string")
    # Contact 2 Address One
    q = Factory(:question, :reference_identifier => "C_ADDR_1_2", :data_export_identifier => "PREG_VISIT_1_2.C_ADDR_1_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 1", :response_class => "string")
    # Contact 2 Address Two
    q = Factory(:question, :reference_identifier => "C_ADDR_2_2", :data_export_identifier => "PREG_VISIT_1_2.C_ADDR_2_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 2", :response_class => "string")
    # Contact 2 Unit
    q = Factory(:question, :reference_identifier => "C_UNIT_2", :data_export_identifier => "PREG_VISIT_1_2.C_UNIT_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Unit", :response_class => "string")
    # Contact 2 City
    q = Factory(:question, :reference_identifier => "C_CITY_2", :data_export_identifier => "PREG_VISIT_1_2.C_CITY_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "City", :response_class => "string")
    # Contact 2 State
    q = Factory(:question, :reference_identifier => "C_STATE_2", :data_export_identifier => "PREG_VISIT_1_2.C_STATE_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "IL", :response_class => "answer", :reference_identifier => "14")
    a = Factory(:answer, :question_id => q.id, :text => "MI", :response_class => "answer", :reference_identifier => "23")
    # Contact 2 Zip
    q = Factory(:question, :reference_identifier => "C_ZIPCODE_2", :data_export_identifier => "PREG_VISIT_1_2.C_ZIPCODE_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Zip", :response_class => "string")
    # Contact 2 plus 4
    q = Factory(:question, :reference_identifier => "C_ZIP4_2", :data_export_identifier => "PREG_VISIT_1_2.C_ZIP4_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "plus 4", :response_class => "string")
    # Contact 2 phone
    q = Factory(:question, :reference_identifier => "CONTACT_PHONE_2", :data_export_identifier => "PREG_VISIT_1_2.CONTACT_PHONE_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Phone Number", :response_class => "string")
    survey
  end

  def create_pregnancy_visit_1_survey_with_telephone_operational_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHI_P2_V2.0", :access_code => "ins-que-pregvisit1-int-ehpbhi-p2-v2-0_test")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    # Cell Phone
    q = Factory(:question, :reference_identifier => "CELL_PHONE", :data_export_identifier => "PREG_VISIT_1_2.CELL_PHONE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Phone Number", :response_class => "string")
    # Can call cell?
    q = Factory(:question, :reference_identifier => "CELL_PHONE_2", :data_export_identifier => "PREG_VISIT_1_2.CELL_PHONE_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Yes", :response_class => "answer", :reference_identifier => "1")
    a = Factory(:answer, :question_id => q.id, :text => "No", :response_class => "answer", :reference_identifier => "2")
    # Can text?
    q = Factory(:question, :reference_identifier => "CELL_PHONE_4", :data_export_identifier => "PREG_VISIT_1_2.CELL_PHONE_4", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Yes", :response_class => "answer", :reference_identifier => "1")
    a = Factory(:answer, :question_id => q.id, :text => "No", :response_class => "answer", :reference_identifier => "2")

    survey
  end

  def create_pregnancy_visit_1_survey_with_email_operational_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHI_P2_V2.0", :access_code => "ins-que-pregvisit1-int-ehpbhi-p2-v2-0_test")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    # Email
    q = Factory(:question, :reference_identifier => "EMAIL", :data_export_identifier => "PREG_VISIT_1_2.EMAIL", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Email", :response_class => "string")

    survey
  end

  def create_pregnancy_visit_1_saq_with_father_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_SAQ_EHPBHI_P2_V2.0", :access_code => "ins-que-pregvisit1-saq-ehpbhi-p2-v2-0_test")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    # Father Name
    q = Factory(:question, :reference_identifier => "FATHER_NAME", :data_export_identifier => "PREG_VISIT_1_SAQ_2.FATHER_NAME", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Father Name", :response_class => "string")

    survey
  end

  def create_pregnancy_visit_survey_with_birth_address_operational_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHI_P2_V2.0", :access_code => "ins-que-pregvisit1-int-ehpbhi-p2-v2-0_test")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    # Address One
    q = Factory(:question, :reference_identifier => "B_ADDR_1", :data_export_identifier => "PREG_VISIT_1_2.B_ADDR_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 1", :response_class => "string")
    # Address Two
    q = Factory(:question, :reference_identifier => "B_ADDR_2", :data_export_identifier => "PREG_VISIT_1_2.B_ADDR_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 2", :response_class => "string")
    # Unit
    q = Factory(:question, :reference_identifier => "B_UNIT", :data_export_identifier => "PREG_VISIT_1_2.B_UNIT", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Unit", :response_class => "string")
    # City
    q = Factory(:question, :reference_identifier => "B_CITY", :data_export_identifier => "PREG_VISIT_1_2.B_CITY", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "City", :response_class => "string")
    # State
    q = Factory(:question, :reference_identifier => "B_STATE", :data_export_identifier => "PREG_VISIT_1_2.B_STATE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "IL", :response_class => "answer", :reference_identifier => "14")
    a = Factory(:answer, :question_id => q.id, :text => "MI", :response_class => "answer", :reference_identifier => "23")
    # Zip
    q = Factory(:question, :reference_identifier => "B_ZIPCODE", :data_export_identifier => "PREG_VISIT_1_2.B_ZIPCODE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Zip", :response_class => "string")

    survey
  end

  def create_pbs_pregnancy_visit_1_with_birth_institution_operational_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHIPBS_M3.0_V3.0", :access_code => "ins-que-pregvisit1-int-ehpbhipbs-m3-0-v3-0_test")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    # Institution Type
    q = Factory(:question, :reference_identifier => "BIRTH_PLAN", :data_export_identifier => "PREG_VISIT_1_3.BIRTH_PLAN", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "In a hospital,", :response_class => "answer", :reference_identifier => "1")
    a = Factory(:answer, :question_id => q.id, :text => "Refused", :response_class => "answer", :reference_identifier => "neg_1")
    # Institution Name
    q = Factory(:question, :reference_identifier => "BIRTH_PLACE", :data_export_identifier => "PREG_VISIT_1_3.BIRTH_PLACE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "FAKE HOSPITAL MEMORIAL", :response_class => "string")
    a = Factory(:answer, :question_id => q.id, :text => "Refused", :response_class => "answer", :reference_identifier => "neg_1")
    # Address One
    q = Factory(:question, :reference_identifier => "B_ADDRESS_1", :data_export_identifier => "PREG_VISIT_1_3.B_ADDRESS_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 1", :response_class => "string")
    # Address Two
    q = Factory(:question, :reference_identifier => "B_ADDRESS_2", :data_export_identifier => "PREG_VISIT_1_3.B_ADDRESS_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 2", :response_class => "string")
    # Unit
    q = Factory(:question, :reference_identifier => "B_UNIT", :data_export_identifier => "PREG_VISIT_1_3.B_UNIT", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Unit", :response_class => "string")
    # City
    q = Factory(:question, :reference_identifier => "B_CITY", :data_export_identifier => "PREG_VISIT_1_3.B_CITY", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "City", :response_class => "string")
    # State
    q = Factory(:question, :reference_identifier => "B_STATE", :data_export_identifier => "PREG_VISIT_1_3.B_STATE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "IL", :response_class => "answer", :reference_identifier => "14")
    a = Factory(:answer, :question_id => q.id, :text => "MI", :response_class => "answer", :reference_identifier => "23")
    # Zip
    q = Factory(:question, :reference_identifier => "B_ZIPCODE", :data_export_identifier => "PREG_VISIT_1_3.B_ZIPCODE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Zip", :response_class => "string")

    survey
  end

  def create_pbs_pregnancy_visit_1_with_birth_address_operational_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHIPBS_M3.0_V3.0", :access_code => "ins-que-pregvisit1-int-ehpbhipbs-m3-0-v3-0")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    # Address One
    q = Factory(:question, :reference_identifier => "B_ADDRESS_1", :data_export_identifier => "PREG_VISIT_1_3.B_ADDRESS_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 1", :response_class => "string")
    # Address Two
    q = Factory(:question, :reference_identifier => "B_ADDRESS_2", :data_export_identifier => "PREG_VISIT_1_3.B_ADDRESS_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 2", :response_class => "string")
    # City
    q = Factory(:question, :reference_identifier => "B_CITY", :data_export_identifier => "PREG_VISIT_1_3.B_CITY", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "City", :response_class => "string")
    # State
    q = Factory(:question, :reference_identifier => "B_STATE", :data_export_identifier => "PREG_VISIT_1_3.B_STATE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "IL", :response_class => "answer", :reference_identifier => "14")
    a = Factory(:answer, :question_id => q.id, :text => "MI", :response_class => "answer", :reference_identifier => "23")
    # Zip
    q = Factory(:question, :reference_identifier => "B_ZIPCODE", :data_export_identifier => "PREG_VISIT_1_3.B_ZIPCODE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Zip", :response_class => "string")

    survey
  end

  def create_pbs_pregnancy_visit_1_with_race_operational_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHIPBS_M3.0_V3.0", :access_code => "ins-que-pregvisit1-int-ehpbhipbs-m3-0-v3-0")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    # Race New
    q = Factory(:question, :reference_identifier => "RACE_NEW", :data_export_identifier => "PREG_VISIT_1_RACE_NEW_3.RACE_NEW", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "White", :response_class => "answer", :reference_identifier => "1")
    a = Factory(:answer, :question_id => q.id, :text => "Black or African American", :response_class => "answer", :reference_identifier => "2")
    a = Factory(:answer, :question_id => q.id, :text => "Asian", :response_class => "answer", :reference_identifier => "4")
    a = Factory(:answer, :question_id => q.id, :text => "Vietnamese", :response_class => "answer", :reference_identifier => "9")

    # Race New Other
    q = Factory(:question, :reference_identifier => "RACE_NEW_OTH", :data_export_identifier => "PREG_VISIT_1_RACE_NEW_3.RACE_NEW_OTH", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :response_class => 'string', :text => 'SPECIFY')

    # Race One
    q = Factory(:question, :reference_identifier => "RACE_1", :data_export_identifier => "PREG_VISIT_1_RACE_1_3.RACE_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Black or African American", :response_class => "answer", :reference_identifier => "2")
    a = Factory(:answer, :question_id => q.id, :text => "Other", :response_class => "answer", :reference_identifier => "neg_5")
    a = Factory(:answer, :question_id => q.id, :text => "Asian", :response_class => "answer", :reference_identifier => "4")

    # Race One Other
    q = Factory(:question, :reference_identifier => "RACE_1_OTH", :data_export_identifier => "PREG_VISIT_1_RACE_1_3.RACE_1_OTH", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :response_class => 'string', :text => 'SPECIFY')

    survey
  end

  def create_pbs_pregnancy_visit_1_with_work_address_operational_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHIPBS_M3.0_V3.0", :access_code => "ins-que-pregvisit1-int-ehpbhipbs-m3-0-v3-0_test")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    # Address One
    q = Factory(:question, :reference_identifier => "WORK_ADDRESS_1", :data_export_identifier => "PREG_VISIT_1_3.WORK_ADDRESS_1", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 1", :response_class => "string")
    # Address Two
    q = Factory(:question, :reference_identifier => "WORK_ADDRESS_2", :data_export_identifier => "PREG_VISIT_1_3.WORK_ADDRESS_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 2", :response_class => "string")
    # Unit
    q = Factory(:question, :reference_identifier => "WORK_UNIT", :data_export_identifier => "PREG_VISIT_1_3.WORK_UNIT", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Unit", :response_class => "string")
    # City
    q = Factory(:question, :reference_identifier => "WORK_CITY", :data_export_identifier => "PREG_VISIT_1_3.WORK_CITY", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "City", :response_class => "string")
    # State
    q = Factory(:question, :reference_identifier => "WORK_STATE", :data_export_identifier => "PREG_VISIT_1_3.WORK_STATE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "IL", :response_class => "answer", :reference_identifier => "14")
    a = Factory(:answer, :question_id => q.id, :text => "MI", :response_class => "answer", :reference_identifier => "23")
    # Zip
    q = Factory(:question, :reference_identifier => "WORK_ZIP", :data_export_identifier => "PREG_VISIT_1_3.WORK_ZIP", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Zip", :response_class => "string")
    # Zip 4
    q = Factory(:question, :reference_identifier => "WORK_ZIP4", :data_export_identifier => "PREG_VISIT_1_3.WORK_ZIP4", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "plus 4", :response_class => "string")

    survey
  end

  def create_pbs_pregnancy_visit_1_with_due_date
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHIPBS_M3.0_V3.0", :access_code => "ins-que-pregvisit1-int-ehpbhipbs-m3-0-v3-0_test")
    survey_section = Factory(:survey_section, :survey_id => survey.id)
    # Pregnant
    q = Factory(:question, :reference_identifier => "PREGNANT", :data_export_identifier => "PREG_VISIT_1_3.PREGNANT", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Yes", :response_class => "answer", :reference_identifier => "1")

    # Due Date
    q = Factory(:question, :reference_identifier => "DUE_DATE_MM", :data_export_identifier => "PREG_VISIT_1_3.DUE_DATE_MM", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Due Date MM", :response_class => "string")
    a = Factory(:answer, :question_id => q.id, :text => "Refused", :response_class => "answer", :reference_identifier => "neg_1")
    a = Factory(:answer, :question_id => q.id, :text => "Don't know", :response_class => "answer", :reference_identifier => "neg_2")

    q = Factory(:question, :reference_identifier => "DUE_DATE_DD", :data_export_identifier => "PREG_VISIT_1_3.DUE_DATE_DD", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Due Date DD", :response_class => "string")
    a = Factory(:answer, :question_id => q.id, :text => "Refused", :response_class => "answer", :reference_identifier => "neg_1")
    a = Factory(:answer, :question_id => q.id, :text => "Don't know", :response_class => "answer", :reference_identifier => "neg_2")

    q = Factory(:question, :reference_identifier => "DUE_DATE_YY", :data_export_identifier => "PREG_VISIT_1_3.DUE_DATE_YY", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Due Date YY", :response_class => "string")
    a = Factory(:answer, :question_id => q.id, :text => "Refused", :response_class => "answer", :reference_identifier => "neg_1")
    a = Factory(:answer, :question_id => q.id, :text => "Don't know", :response_class => "answer", :reference_identifier => "neg_2")

    # Date Last Period
    q = Factory(:question, :reference_identifier => "DATE_PERIOD", :data_export_identifier => "PREG_VISIT_1_3.DATE_PERIOD", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Date Last Period", :response_class => "string")
    a = Factory(:answer, :question_id => q.id, :text => "Refused", :response_class => "answer", :reference_identifier => "neg_1")
    a = Factory(:answer, :question_id => q.id, :text => "Don't know", :response_class => "answer", :reference_identifier => "neg_2")
    survey
  end

  def create_pregnancy_visit_1_saq_survey_with_father_operational_data
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_SAQ_EHPBHI_P2_V2.0", :access_code => "ins-que-pregvisit1-saq-ehpbhi-p2-v2-0_test")
    survey_section = Factory(:survey_section, :survey_id => survey.id)
    # Father Name
    q = Factory(:question, :reference_identifier => "FATHER_NAME", :data_export_identifier => "PREG_VISIT_1_SAQ_2.FATHER_NAME", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Father Name", :response_class => "string")
    # Father Name
    q = Factory(:question, :reference_identifier => "FATHER_AGE", :data_export_identifier => "PREG_VISIT_1_SAQ_2.FATHER_AGE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Father Name", :response_class => "integer")
    # Address One
    q = Factory(:question, :reference_identifier => "F_ADDR1_2", :data_export_identifier => "PREG_VISIT_1_SAQ_2.F_ADDR1_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 1", :response_class => "string")
    # Address Two
    q = Factory(:question, :reference_identifier => "F_ADDR_2_2", :data_export_identifier => "PREG_VISIT_1_SAQ_2.F_ADDR_2_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Address 2", :response_class => "string")
    # Unit
    q = Factory(:question, :reference_identifier => "F_UNIT_2", :data_export_identifier => "PREG_VISIT_1_SAQ_2.F_UNIT_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Unit", :response_class => "string")
    # City
    q = Factory(:question, :reference_identifier => "F_CITY_2", :data_export_identifier => "PREG_VISIT_1_SAQ_2.F_CITY_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "City", :response_class => "string")
    # State
    q = Factory(:question, :reference_identifier => "F_STATE_2", :data_export_identifier => "PREG_VISIT_1_SAQ_2.F_STATE_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "IL", :response_class => "answer", :reference_identifier => "14")
    a = Factory(:answer, :question_id => q.id, :text => "MI", :response_class => "answer", :reference_identifier => "23")
    # Zip
    q = Factory(:question, :reference_identifier => "F_ZIPCODE_2", :data_export_identifier => "PREG_VISIT_1_SAQ_2.F_ZIPCODE_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Zip", :response_class => "string")
    # Zip
    q = Factory(:question, :reference_identifier => "F_ZIP4_2", :data_export_identifier => "PREG_VISIT_1_SAQ_2.F_ZIP4_2", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Zip", :response_class => "string")
    # Phone
    q = Factory(:question, :reference_identifier => "F_PHONE", :data_export_identifier => "PREG_VISIT_1_SAQ_2.F_PHONE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Phone Number", :response_class => "string")
    survey
  end

  def create_screener_survey_with_fields_used_in_pv1_prepopulation
    survey = Factory(:survey, :title => "INS_QUE_PBSamplingScreen_INT_PBS_M3.0_V1.0", :access_code => "ins-que-pbsamplingscreen-int-pbs-m3-0-v1-0")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    q = Factory(:question, :reference_identifier => "OWN_HOME", :data_export_identifier => "PBS_ELIG_SCREENER.OWN_HOME", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Yes", :response_class => "answer", :reference_identifier => "1")

    survey
  end

  def create_pre_preg_survey_with_fields_used_in_pv1_prepopulation
    survey = Factory(:survey, :title => "INS_QUE_PrePreg_INT_EHPBHI_P2_V1.1", :access_code => "ins-que-prepreg-int-ehpbhi-p2-v1-1")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    q = Factory(:question, :reference_identifier => "OWN_HOME", :data_export_identifier => "PRE_PREG.OWN_HOME", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Yes", :response_class => "answer", :reference_identifier => "1")

    q = Factory(:question, :reference_identifier => "RECENT_MOVE", :data_export_identifier => "PRE_PREG.RECENT_MOVE", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "Yes", :response_class => "answer", :reference_identifier => "1")
    a = Factory(:answer, :question_id => q.id, :text => "No", :response_class => "answer", :reference_identifier => "2")

    survey
  end

  def create_pregnancy_visit_survey_with_prepopulated_fields
    survey = Factory(:survey, :title => "INS_QUE_PregVisit1_INT_EHPBHI_M3.0_V3.0", :access_code => "ins-que-pregvisit1-int-ehpbhi-m3-0-v3-0")
    survey_section = Factory(:survey_section, :survey_id => survey.id)

    # prepopulated mode of contact
    q = Factory(:question, :reference_identifier => "prepopulated_mode_of_contact", :data_export_identifier => "prepopulated_mode_of_contact", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "CAPI", :response_class => "answer", :reference_identifier => "capi")
    a = Factory(:answer, :question_id => q.id, :text => "CATI", :response_class => "answer", :reference_identifier => "cati")
    a = Factory(:answer, :question_id => q.id, :text => "PAPI", :response_class => "answer", :reference_identifier => "papi")

    # prepopulated_should_show_height
    q = Factory(:question, :reference_identifier => "prepopulated_should_show_height", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "TRUE", :response_class => "answer", :reference_identifier => "true")
    a = Factory(:answer, :question_id => q.id, :text => "FALSE", :response_class => "answer", :reference_identifier => "false")

    # prepopulated_should_show_recent_move_for_preg_visit_one
    q = Factory(:question, :reference_identifier => "prepopulated_should_show_recent_move_for_preg_visit_one", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "TRUE", :response_class => "answer", :reference_identifier => "true")
    a = Factory(:answer, :question_id => q.id, :text => "FALSE", :response_class => "answer", :reference_identifier => "false")

    # prepopulated_is_first_pregnancy_visit_one
    q = Factory(:question, :reference_identifier => "prepopulated_is_first_pregnancy_visit_one", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "TRUE", :response_class => "answer", :reference_identifier => "true")
    a = Factory(:answer, :question_id => q.id, :text => "FALSE", :response_class => "answer", :reference_identifier => "false")

    # prepopulated_is_pre_pregnancy_information_available_and_recent_move_coded_as_one
    q = Factory(:question, :reference_identifier => "prepopulated_is_pre_pregnancy_information_available_and_recent_move_coded_as_one", :survey_section_id => survey_section.id)
    a = Factory(:answer, :question_id => q.id, :text => "TRUE", :response_class => "answer", :reference_identifier => "true")
    a = Factory(:answer, :question_id => q.id, :text => "FALSE", :response_class => "answer", :reference_identifier => "false")

    survey
  end

end
