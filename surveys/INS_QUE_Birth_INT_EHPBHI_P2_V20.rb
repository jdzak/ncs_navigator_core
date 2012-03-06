survey "INS_QUE_Birth_INT_EHPBHI_P2_V2.0" do
  section "Interview introduction", :reference_identifier=>"Birth_INT" do
    q_TIME_STAMP_1 "Insert date/time stamp",
    :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_1"
    a :datetime, :custom_class => "datetime"

    label "Thank you for agreeing to participate in the National Children’s Study. This interview will
    take about 20 minutes. Your answers are important to us. There are no right or wrong answers. We
    will ask you about yourself, your baby’s birth, and your plans once you return home. You can skip
    over any question or stop the interview at any time. We will keep everything that you tell us
    confidential.",
    :help_text => "If additional information is needed, say [You may be receiving government benefits,
    such as Social Security or Medicaid. Nothing will happen to those benefits if you decide to take part or not take part in this study.]
    Continue unless participant asks questions or refuses to participate. If participant refuses, disposition contact as a refusal and
    complete a non-interview report."
  end
  section "Interviewer-completed questions", :reference_identifier=>"Birth_INT" do
    q_MULTIPLE "Was this a multiple birth?",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.MULTIPLE"
    a_1 "Yes"
    a_2 "No"

    # TODO
    #    PROGRAMMER INSTRUCTION:
    #    •  USE MULTIPLE TO CODE {BABY/BABIES} AND {BABY’S/BABIES’} FIELDS AS APPROPRIATE THROUGHOUT INSTRUMENT
    #    o  IF MULTIPLE=2, DISPLAY BABY.
    #    o	IF MULTIPLE=1, DISPLAY BABIES.

    q_MULTIPLE_NUM "How many babies were delivered?",
    :data_export_identifier=>"BIRTH_VISIT_2.MULTIPLE_NUM"
    a "Number", :integer
    dependency :rule=>"A"
    condition_A :q_MULTIPLE, "==", :a_1

    q_CHILD_DOB "What was the {BABY’S/BABIES’} date of birth?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.CHILD_DOB"
    a "Date", :string, :custom_class => "date"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
  end
  section "Baby characteristics", :reference_identifier=>"Birth_INT" do
    # TODO
    #     PROGRAMMER INSTRUCTIONS:
    #     • LOOP THROUGH QUESTIONS BABY_NAME THROUGH BABY_BWT FOR TOTAL NUMBER OF BABIES DELIVERED
    #     •	BASED ON NUMBER OF LOOPS, DISPLAY APPROPRIATE ADJECTIVES (E.G. “FIRST” OR “NEXT,” “BABY” OR “BABIES”)

    # TODO
    # PROGRAMMER INSTRUCTIONS:
    # • IF MULTIPLE = 1 AND MULTIPLE_NUM = 2 AND FIRST LOOP, DISPLAY: “Let’s start with your first twin birth.
    # What name would you like me to use to talk about your first baby?”
    # • IF MULTIPLE = 1 AND MULTIPLE_NUM = 3 AND FIRST LOOP, DISPLAY: ““Let’s start with your first triplet birth.
    # What name would you like me to use to talk about your first baby?”
    # • IF MULTIPLE = 1 AND MULTIPLE_NUM = ≥ 4 AND FIRST LOOP, DISPLAY: ““Let’s start with your first higher order birth.
    # What name would you like me to use to talk about your first baby?”
    # • IF MULTIPLE = 1 AND MULTIPLE_NUM = 2 AND SECOND LOOP, DISPLAY: “Now let’s talk about your next baby. What name
    # would you like me to use to talk about your next baby?”
    # • IF MULTIPLE = 1 AND MULTIPLE_NUM = ≥ 3 AND SECOND OR HIGHER LOOP, DISPLAY: “Now let’s talk about your next baby.
    # What name would you like me to use to talk about your next baby?”
    # • IF MULTIPLE =2, DISPLAY: “What name would you like me to use to talk about your baby?”

    # repeater "Information on the babies" do
    #   q_BABY_NAME_TWINS "During this interview, we would like to refer to your {baby/babies} by name.
    #   Let’s start with your first/next twin birth. What name would you like me to use to talk about your first/next baby?",
    #   :pick=>:one,
    #   :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_NAME"
    #   a_1 "Name provided"
    #   a_2 "Initials provided"
    #   a_3 "No official name selected"
    #   a_neg_1 "Refused"
    #   a_neg_2 "Don't know"
    #   dependency :rule=>"A and B"
    #   condition_A :q_MULTIPLE, "==", :a_1
    #   condition_B :q_MULTIPLE_NUM, "==", {:integer_value => "2"}
    #
    #   q_BABY_NAME_TRIPLETS "During this interview, we would like to refer to your {baby/babies} by name. Let’s start with your
    #   first/next triplet birth. What name would you like me to use to talk about your first/next baby?",
    #   :pick=>:one,
    #   :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_NAME"
    #   a_1 "Name provided"
    #   a_2 "Initials provided"
    #   a_3 "No official name selected"
    #   a_neg_1 "Refused"
    #   a_neg_2 "Don't know"
    #   dependency :rule=>"A and B"
    #   condition_A :q_MULTIPLE, "==", :a_1
    #   condition_B :q_MULTIPLE_NUM, "==", {:integer_value => "3"}
    #
    #   q_BABY_NAME_FOUR_OR_MORE "During this interview, we would like to refer to your {baby/babies} by name. Let’s start with your
    #   first higher order birth. What name would you like me to use to talk about your first baby?",
    #   :help_text => "For the second loop read; \"Now let’s talk about your next baby. What name would you like me to use to talk about your next baby?\"",
    #   :pick=>:one,
    #   :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_NAME"
    #   a_1 "Name provided"
    #   a_2 "Initials provided"
    #   a_3 "No official name selected"
    #   a_neg_1 "Refused"
    #   a_neg_2 "Don't know"
    #   dependency :rule=>"A and B"
    #   condition_A :q_MULTIPLE, "==", :a_1
    #   condition_B :q_MULTIPLE_NUM, ">", {:integer_value => "3"}
    #
    #   q_BABY_NAME_ONE "During this interview, we would like to refer to your {baby/babies} by name. What name would you like me to use to talk about your baby?",
    #   :pick=>:one,
    #   :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_NAME"
    #   a_1 "Name provided"
    #   a_2 "Initials provided"
    #   a_3 "No official name selected"
    #   a_neg_1 "Refused"
    #   a_neg_2 "Don't know"
    #   dependency :rule=>"A"
    #   condition_A :q_MULTIPLE, "==", :a_2
  # end

    q_BABY_NAME "During this interview, we would like to refer to your {baby/babies} by name.",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_NAME"
    a_1 "Name provided"
    a_2 "Initials provided"
    a_3 "No official name selected"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    group "First, middle and last name" do
      dependency :rule=>"A or B"
      condition_A :q_BABY_NAME, "==", :a_1
      condition_B :q_BABY_NAME, "==", :a_2

      q_BABY_FNAME "First name",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_FNAME"
      a_1 "First name", :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_BABY_MNAME "Middle name",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_MNAME"
      a_1 "Middle  name", :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_BABY_LNAME "Last name",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_LNAME"
      a_1 "Last name", :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
    end

    q_BABY_SEX "What is the sex of the baby?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_SEX"
    a_1 "Male"
    a_2 "Female"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    # TODO
    #     PROGRAMMER INSTRUCTIONS:
    #     • IF MULTIPLE =2 AND BABY_SEX=1, USE “he” IN REMAINDER OF QUESTIONNAIRE. IF MULTIPLE =2 AND IF BABY_SEX=2, ,
    # USE “she” IN REMAINDER OF QUESTIONNAIRE.
    #     • IF MULTIPLE=1, USE “they” IN REMAINDER OF QUESTIONNAIRE. IF MULTIPLE BIRTHS, PRE-FILL EITHER “your babies”
    # OR ACTUAL NAMES – SEPARATED BY “and” AS APPROPRIATE THROUGHOUT QUESTIONNAIRE.
    #     • IF MULTIPLE=2 AND IF BABY_SEX=-1 OR -2, USE BABY_NAME IN REMAINDER OF QUESTIONNARE FOR “he” or “she.”
    #     •	IF BABY_NAME=3, -1 OR -2 AND BABY_SEX=-1 OR -2, USE “your baby” IN REMAINDER OF QUESTIONNAIRE FOR ‘she” or “he.”

    q_BABY_BWT_LB "How much did [BABY_NAME] weigh when [he/she] was born?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_BWT_LB"
    a_lbs "Pounds:", :integer
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    q_BABY_BWT_OZ "How much did [BABY_NAME] weigh when [he/she] was born?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_BABY_NAME_2.BABY_BWT_OZ"
    a_lbs "Ounces:", :integer
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    q_LIVE_MOM "When [BABY’S NAME leaves] the hospital will [he/she] live with you?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.LIVE_MOM"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_MULTIPLE, "==", :a_2

    q_LIVE_MOM_ALT "When your babies leave the hospital will they live with you?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.LIVE_MOM"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_MULTIPLE, "==", :a_1

    q_LIVE_OTH "With whom will {he/she/they} live?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.LIVE_OTH"
    a_1 "Baby’s father"
    a_2 "Baby’s grandparent(s)"
    a_3 "Other family member"
    a_4 "Placing in foster care"
    a_5 "Placing for adoption"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A or B"
    condition_A :q_LIVE_MOM, "!=", :a_1
    condition_B :q_LIVE_MOM_ALT, "!=", :a_1

    q_TIME_STAMP_2 "Insert date/time stamp",
    :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_2"
    a :datetime, :custom_class => "datetime"
  end
  section "Housing characteristics", :reference_identifier=>"Birth_INT" do
    q_RECENT_MOVE "Have you moved or changed your housing situation since we contacted you last?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.RECENT_MOVE"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    group "Housing information" do
      dependency :rule=>"A"
      condition_A :q_RECENT_MOVE, "==", :a_1

      q_OWN_HOME "Is your current home...",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.OWN_HOME"
      a_1 "Owned or being bought by you or someone in your household"
      a_2 "Rented by you or someone in your household, or"
      a_3 "Occupied without payment of rent?"
      a_neg_5 "Some other arrangement"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_OWN_HOME_OTH "Other specify",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.OWN_HOME_OTH"
      a "Specify", :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_OWN_HOME, "==", :a_neg_5

      q_AGE_HOME "Can you tell us when your home or building was built? Was it between...",
      :help_text => "Use showcard with categories.",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.AGE_HOME"
      a_1 "2001 to present,"
      a_2 "1981 to 2000,"
      a_3 "1961 to 1980,"
      a_4 "1941 to 1960, OR"
      a_5 "1940 or before"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      label "How long have you lived in this home?"

      q_LENGTH_RESIDE "Length reside: number (e.g., 5)",
      :help_text => "Verify if value > 18 years",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.LENGTH_RESIDE"
      a "Number", :integer
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_LENGTH_RESIDE_UNIT "Length reside: units (e.g., months)",
      :help_text => "Verify if value > 18 years",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.LENGTH_RESIDE_UNIT"
      a_1 "Weeks"
      a_2 "Months"
      a_3 "Years"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
    end

    q_TIME_STAMP_3 "Insert date/time stamp",
    :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_3"
    a :datetime, :custom_class => "datetime"
  end
  section "Environmental exposures", :reference_identifier=>"Birth_INT" do
    q_RENOVATE "The next few questions ask about any recent additions or renovations to your home.
    Since our last contact, have any additions been built onto your home to make it bigger or renovations
    or other construction been done in your home? Include only major projects. Do not count smaller projects
    such as painting or wallpapering, carpeting, or refinishing floors..",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.RENOVATE"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    q_RENOVATE_ROOM "Which rooms were renovated?",
    :help_text => "Select all that apply.",
    :pick => :any,
    :data_export_identifier=>"BIRTH_VISIT_RENOVATE_ROOM_2.RENOVATE_ROOM"
    a_1 "Kitchen"
    a_2 "Living room"
    a_3 "Hall/landing"
    a_4 "Baby’s bedroom"
    a_5 "Other bedroom"
    a_6 "Bathroom/toilet"
    a_7 "Basement"
    a_neg_5 "Other"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule => "A"
    condition_A :q_RENOVATE, "==", :a_1

    q_RENOVATE_ROOM_OTH "Other room",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_RENOVATE_ROOM_2.RENOVATE_ROOM_OTH"
    a "Specify", :string
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule => "A and B and C"
    condition_A :q_RENOVATE_ROOM, "==", :a_neg_5
    condition_B :q_RENOVATE_ROOM, "!=", :a_neg_1
    condition_C :q_RENOVATE_ROOM, "!=", :a_neg_2

    q_DECORATE "Since our last contact, were any smaller projects done in your home, such as painting,
    wallpapering, refinishing floors, or installing new carpet?", :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.DECORATE"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    q_DECORATE_ROOM "In which rooms were these smaller projects done?",
    :help_text => "Select all that apply", :pick=>:any,
    :data_export_identifier=>"BIRTH_VISIT_DECORATE_ROOM_2.DECORATE_ROOM"
    a_1 "Kitchen"
    a_2 "Living room"
    a_3 "Hall/landing"
    a_4 "Baby's bedroom"
    a_5 "Other bedroom"
    a_6 "Bathroom/toilet"
    a_7 "Basement"
    a_neg_5 "Other"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_DECORATE, "==", :a_1

    q_DECORATE_ROOM_OTH "Other rooms where smaller projects were done",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_DECORATE_ROOM_2.DECORATE_ROOM_OTH"
    a_1 "Specify", :string
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A and (B and C)"
    condition_A :q_DECORATE_ROOM, "==", :a_neg_5
    condition_B :q_DECORATE_ROOM, "!=", :a_neg_1
    condition_C :q_DECORATE_ROOM, "!=", :a_neg_2

    q_SMOKE "Currently, do you or others in your household smoke cigarettes, cigarillos, cigars, pipes or other tobacco products?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.SMOKE"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    q_SMOKE_LOCATE "Do those who smoke usually smoke indoors, outdoors, or both indoors and outdoors?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.SMOKE_LOCATE"
    a_1 "Indoors"
    a_2 "Outdoors"
    a_3 "Both"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_SMOKE, "==", :a_1

    q_TIME_STAMP_4 "Insert date/time stamp",
    :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_4"
    a :datetime, :custom_class => "datetime"
  end
  section "Infant feeding", :reference_identifier=>"Birth_INT" do
    q_FED_BABY "Have you fed {[BABY’S NAME]/your babies} since [his/her/their] birth?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.FED_BABY"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    q_HOW_FED "How have you fed your baby?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.HOW_FED"
    a_1 "Breast only"
    a_2 "Bottle only"
    a_3 "Both breast and bottle"
    a_neg_5 "Other"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_FED_BABY, "==", :a_1

    group "Feeding information" do
      dependency :rule=>"A or B"
      condition_A :q_LIVE_MOM, "!=", :a_2
      condition_B :q_LIVE_MOM_ALT, "!=", :a_2

      q_PLAN_FEED "After you leave the hospital do you plan to feed the {baby/babies} breast milk, formula or both?",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.PLAN_FEED"
      a_1 "Breast milk"
      a_2 "Formula"
      a_3 "Both breast milk and formula"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_TIME_STAMP_5 "Insert date/time stamp",
      :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_5"
      a :datetime, :custom_class => "datetime"
    end
  end
  section "Infant sleep", :reference_identifier=>"Birth_INT" do
    group "Sleep information" do
      dependency :rule=>"A or B"
      condition_A :q_LIVE_MOM, "!=", :a_2
      condition_B :q_LIVE_MOM_ALT, "!=", :a_2

      q_POS_HOSP "Do the nurses here in the hospital usually put your babies to sleep on their stomachs, backs, or sides?",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.POS_HOSP"
      a_1 "Stomach"
      a_2 "Back"
      a_3 "Side"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_MULTIPLE, "==", :a_1

      q_POS_HOSP_ALT "Do the nurses here in the hospital usually put {BABY’S NAME/your baby }} to sleep on [his/her] stomach, back, or side?",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.POS_HOSP"
      a_1 "Stomach"
      a_2 "Back"
      a_3 "Side"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_MULTIPLE, "==", :a_2

      q_POS_HOME "In what position do you plan to put {[BABY’S NAME]/your babies} to sleep at home?",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.POS_HOME"
      a_1 "Stomach"
      a_2 "Back"
      a_3 "Side"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_SLEEP_ROOM "When you go home from the hospital do you plan for {[BABY’S NAME]/your babies} to sleep...",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.SLEEP_ROOM"
      a_1 "In [his/her/their] own room,"
      a_2 "In a room with other children,"
      a_3 "In your bedroom, or"
      a_4 "Another location?"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_BED "When you go home from the hospital do you plan for {[BABY’S NAME]/your babies} to sleep in...",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.BED"
      a_1 "A bassinette,"
      a_2 "A crib,"
      a_3 "A co-sleeper,"
      a_4 "An adult bed alone,"
      a_5 "An adult bed with you,"
      a_6 "An adult bed with another child, or"
      a_neg_5 "Something else"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_BED_OTH "Other",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.BED_OTH"
      a "Specify", :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_BED, "==", :a_neg_5

      q_TIME_STAMP_6 "Insert date/time stamp",
      :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_6"
      a :datetime, :custom_class => "datetime"
    end
  end
  section "Well baby care and immunizations", :reference_identifier=>"Birth_INT" do
    group "Well baby care and immunizations information" do
      dependency :rule=>"A or B"
      condition_A :q_LIVE_MOM, "!=", :a_2
      condition_B :q_LIVE_MOM_ALT, "!=", :a_2

      q_HCARE "Where do you plan to take your new {baby/babies} for well-baby checkups?",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.HCARE"
      a_1 "Clinic or health center"
      a_2 "Doctor's office or Health Maintenance Organization (HMO)"
      a_3 "Hospital outpatient department"
      a_neg_5 "Some other place"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_HCARE_OTH "Other",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.HCARE_OTH"
      a "Specify", :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_HCARE, "==", :a_neg_5

      q_VACCINE "Do you plan for your new {baby/babies} to have well-baby shots or vaccinations?",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.VACCINE"
      a_1 "Yes"
      a_2 "Yes, on a delayed schedule"
      a_3 "No"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_TIME_STAMP_7 "Insert date/time stamp",
      :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_7"
      a :datetime, :custom_class => "datetime"
    end
  end
  section "Work and plans for childcare", :reference_identifier=>"Birth_INT" do
    group "Work and plans for childcare" do
      dependency :rule=>"A or B"
      condition_A :q_LIVE_MOM, "!=", :a_2
      condition_B :q_LIVE_MOM_ALT, "!=", :a_2

      q_EMPLOY2 "Are you currently employed?",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.EMPLOY2"
      a_1 "Yes"
      a_2 "No"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      label "When do you plan to return to your current job?"
      dependency :rule=>"A"
      condition_A :q_EMPLOY2, "!=", :a_2

      q_RETURN_JOB "Number",
      :help_text => "Verify if value > 1 year or > 12 months or > 52 weeks or > 365 days",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.RETURN_JOB"
      a_num "Number", :integer
      a_neg_7 "Doesn’t plan to return to work"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_EMPLOY2, "!=", :a_2

      q_RETURN_JOB_UNIT "Unit",
      :help_text => "Verify if value > 1 year or > 12 months or > 52 weeks or > 365 days",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.RETURN_JOB_UNIT"
      a_1 "Days"
      a_2 "Weeks"
      a_3 "Months"
      a_4 "Years"
      a_neg_7 "Doesn’t plan to return to work"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_EMPLOY2, "!=", :a_2

      q_CHILDCARE "Next I would like to ask you a few questions about your plans for childcare.
      Do you plan for {(BABY’S NAME)/your babies} to receive regularly scheduled care from someone
      other than you or the {baby’s/babies’} father?",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.CHILDCARE"
      a_1 "Yes"
      a_2 "No"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_CCARE_TYPE "Please describe the type of setting in which most of the childcare will occur.",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.CCARE_TYPE"
      a_1 "Participants home"
      a_2 "Other private home"
      a_3 "Child care center"
      a_neg_5 "Other"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_CHILDCARE, "!=", :a_2

      q_CCARE_TYPE_OTH "Other type",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.CCARE_TYPE_OTH"
      a "Specify", :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_CCARE_TYPE, "==", :a_neg_5

      q_CCARE_WHO "Which best describes the person who will be caring for {[BABY’S NAME]/your babies}?",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.CCARE_WHO"
      a_1 "Your mother"
      a_2 "Your father"
      a_3 "Your mother in-law"
      a_4 "Your father in-law"
      a_5 "Guardian"
      a_6 "Other relative"
      a_7 "Friend"
      a_8 "Nanny"
      a_9 "Professional in home daycare"
      a_10 "Professional center based daycare"
      a_neg_5 "Other"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_CHILDCARE, "!=", :a_2

      q_REL_CARE_OTH "Other relative",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.REL_CARE_OTH"
      a "Specify", :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_CCARE_WHO, "==", :a_6

      q_CCARE_WHO_OTH "Other type of care",
      :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.CCARE_WHO_OTH"
      a "Specify", :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
      dependency :rule=>"A"
      condition_A :q_CCARE_WHO, "==", :a_neg_5

      q_TIME_STAMP_8 "Insert date/time stamp",
      :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_8"
      a :datetime, :custom_class => "datetime"
    end
  end
  section "Tracing questions", :reference_identifier=>"Birth_INT" do
    label "These next few questions will help us to contact you again in the future."

    label "What is your full name?",
    :help_text => "Confirm spelling of first name if not previously collected and of last name for all participants."

    q_R_FNAME "First name", :pick => :one, :data_export_identifier=>"BIRTH_VISIT_2.R_FNAME"
    a :string
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    q_R_LNAME "Last name", :pick => :one, :data_export_identifier=>"BIRTH_VISIT_2.R_LNAME"
    a :string
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    q_PHONE_NBR "What is the best phone number to reach you?",
    :help_text => "Enter phone number and confirm. If participant does not have a telephone number, ask where participant
    receives telephone calls, even if she does not have her own phone. Ask for and record that number.",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.PHONE_NBR"
    a_phone "Phone number", :string
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    a_neg_7 "Participant has no telephone/not applicable"

    q_PHONE_TYPE "Is that your home, work, cell, or another phone number?",
    :help_text => "Confirm if known.",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.PHONE_TYPE"
    a_1 "Home"
    a_2 "Work"
    a_3 "Cell"
    a_4 "Friend/relative"
    a_neg_5 "Other"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_PHONE_NBR, "==", :a_phone

    q_FRIEND_PHONE_OTH "Friend's phone number",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.FRIEND_PHONE_OTH"
    a "Specify", :string
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_PHONE_TYPE, "==", :a_4

    q_PHONE_TYPE_OTH "Other",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.PHONE_TYPE_OTH"
    a "Specify", :string
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_PHONE_TYPE, "==", :a_neg_5

    q_HOME_PHONE "What is your home phone number?",
    :help_text => "Enter phone number and confirm.",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.HOME_PHONE"
    a "Phone", :string
    a_1 "No home number"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_PHONE_TYPE, "!=", :a_1

    q_CELL_PHONE_1 "Do you have a personal cell phone?",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.CELL_PHONE_1"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_PHONE_TYPE, "!=", :a_3

    q_CELL_PHONE_2 "May we use your personal cell phone to make future study appointments or for appointment reminders?",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.CELL_PHONE_2"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A or B"
    condition_A :q_CELL_PHONE_1, "==", :a_1
    condition_B :q_PHONE_TYPE, "==", :a_3

    q_CELL_PHONE_3 "Do you send and receive text messages on your personal cell phone?",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.CELL_PHONE_3"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A or B"
    condition_A :q_CELL_PHONE_1, "==", :a_1
    condition_B :q_PHONE_TYPE, "==", :a_3

    q_CELL_PHONE_4 "May we send text messages to make future study appointments or for appointment reminders?",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.CELL_PHONE_4"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_CELL_PHONE_3, "==", :a_1

    q_CELL_PHONE "What is your personal cell phone number?",
    :help_text => "Enter phone number and confirm.",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.CELL_PHONE"
    a "Phone Number", :string
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"(A and B) or C"
    condition_A :q_CELL_PHONE_1, "==", :a_1
    condition_B :q_PHONE_TYPE, "!=", :a_3
    condition_C :q_PHONE_TYPE, "==", :a_3

    q_TIME_STAMP_9 "Insert date/time stamp",
    :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_9"
    a :datetime, :custom_class => "datetime"

    q_MOVE_INFO "What is the address of your new home?",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.MOVE_INFO"
    a_1 "Address known"
    a_2 "Out of the country"
    a_3 "PO Box address only"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_RECENT_MOVE , "==", :a_1

    group "Address information" do
      dependency :rule=>"A"
      condition_A :q_MOVE_INFO , "==", :a_1

      q_NEW_ADDRESS1 "Address 1 - street/PO Box",
      :data_export_identifier=>"BIRTH_VISIT_2.NEW_ADDRESS1",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_ADDRESS2 "Address 2",
      :data_export_identifier=>"BIRTH_VISIT_2.NEW_ADDRESS2",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_UNIT "Unit",
      :data_export_identifier=>"BIRTH_VISIT_2.NEW_UNIT",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_CITY "City",
      :data_export_identifier=>"BIRTH_VISIT_2.NEW_CITY",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_STATE "State", :display_type => :dropdown, :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.NEW_STATE"
      a_1 "AL"
      a_2 "AK"
      a_3 "AZ"
      a_4 "AR"
      a_5 "CA"
      a_6 "CO"
      a_7 "CT"
      a_8 "DE"
      a_9 "DC"
      a_10 "FL"
      a_11 "GA"
      a_12 "HI"
      a_13 "ID"
      a_14 "IL"
      a_15 "IN"
      a_16 "IA"
      a_17 "KS"
      a_18 "KY"
      a_19 "LA"
      a_20 "ME"
      a_21 "MD"
      a_22 "MA"
      a_23 "MI"
      a_24 "MN"
      a_25 "MS"
      a_26 "MO"
      a_27 "MT"
      a_28 "NE"
      a_29 "NV"
      a_30 "NH"
      a_31 "NJ"
      a_32 "NM"
      a_33 "NY"
      a_34 "NC"
      a_35 "ND"
      a_36 "OH"
      a_37 "OK"
      a_38 "OR"
      a_39 "PA"
      a_40 "RI"
      a_41 "SC"
      a_42 "SD"
      a_43 "TN"
      a_44 "TX"
      a_45 "UT"
      a_46 "VT"
      a_47 "VA"
      a_48 "WA"
      a_49 "WV"
      a_50 "WI"
      a_51 "WY"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_ZIP "ZIP Code",
      :data_export_identifier=>"BIRTH_VISIT_2.NEW_ZIP",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_ZIP4 "ZIP+4",
      :data_export_identifier=>"BIRTH_VISIT_2.NEW_ZIP4",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
    end

    q_SAME_ADDR "Is your mailing address the same as your street address?",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.SAME_ADDR"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_MOVE_INFO , "!=", :a_3

    group "Mailing address information" do
      dependency :rule=>"A or B"
      condition_A :q_SAME_ADDR, "==", :a_2
      condition_B :q_MOVE_INFO , "==", :a_3

      label "What is your mailing address?",
      :help_text => "Prompt as necessary to complete information"

      q_MAIL_ADDRESS1 "Address 1 - street/PO Box",
      :data_export_identifier=>"BIRTH_VISIT_2.MAIL_ADDRESS1",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_MAIL_ADDRESS2 "Address 2",
      :data_export_identifier=>"BIRTH_VISIT_2.MAIL_ADDRESS2",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_MAIL_UNIT "Unit",
      :data_export_identifier=>"BIRTH_VISIT_2.MAIL_UNIT",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_MAIL_CITY "City",
      :data_export_identifier=>"BIRTH_VISIT_2.MAIL_CITY",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_MAIL_STATE "State", :display_type => :dropdown, :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.MAIL_STATE"
      a_1 "AL"
      a_2 "AK"
      a_3 "AZ"
      a_4 "AR"
      a_5 "CA"
      a_6 "CO"
      a_7 "CT"
      a_8 "DE"
      a_9 "DC"
      a_10 "FL"
      a_11 "GA"
      a_12 "HI"
      a_13 "ID"
      a_14 "IL"
      a_15 "IN"
      a_16 "IA"
      a_17 "KS"
      a_18 "KY"
      a_19 "LA"
      a_20 "ME"
      a_21 "MD"
      a_22 "MA"
      a_23 "MI"
      a_24 "MN"
      a_25 "MS"
      a_26 "MO"
      a_27 "MT"
      a_28 "NE"
      a_29 "NV"
      a_30 "NH"
      a_31 "NJ"
      a_32 "NM"
      a_33 "NY"
      a_34 "NC"
      a_35 "ND"
      a_36 "OH"
      a_37 "OK"
      a_38 "OR"
      a_39 "PA"
      a_40 "RI"
      a_41 "SC"
      a_42 "SD"
      a_43 "TN"
      a_44 "TX"
      a_45 "UT"
      a_46 "VT"
      a_47 "VA"
      a_48 "WA"
      a_49 "WV"
      a_50 "WI"
      a_51 "WY"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_MAIL_ZIP "ZIP Code",
      :data_export_identifier=>"BIRTH_VISIT_2.MAIL_ZIP",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_MAIL_ZIP4 "ZIP+4",
      :data_export_identifier=>"BIRTH_VISIT_2.MAIL_ZIP4",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
    end

    q_HAVE_EMAIL "Do you have an email address?", :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.HAVE_EMAIL"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    group "Email information" do
      dependency :rule=>"A"
      condition_A :q_HAVE_EMAIL, "==", :a_1

      q_EMAIL "What is the best email address to reach you?",
      :pick=>:one,
      :help_text=>"Show example of valid email address such as maryjane@email.com",
      :data_export_identifier=>"BIRTH_VISIT_2.EMAIL"
      a_1 "Enter e-mail address:", :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_EMAIL_TYPE "Is that your personal e-mail, work e-mail, or a family or shared e-mail address?",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.EMAIL_TYPE"
      a_1 "Personal"
      a_2 "Work"
      a_3 "Family/shared"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      # TODO
      #     PROGRAMMER INSTRUCTIONS:
      #     • IF PARTICIPANT REPORTED A SHARED EMAIL ADDRESS IN EMAIL_TYPE, SET EMAIL_SHARE AS APPROPRIATE THEN GO TO PLAN_MOVE.
      q_EMAIL_SHARE "Is email shared?",
      :help_text => "If participant reported a shared email address in previous question, set the answer as appropriate.",
      :pick=>:one,
      :data_export_identifier=>"BIRTH_VISIT_2.EMAIL_SHARE"
      a_1 "Yes"
      a_2 "No"
      dependency :rule=>"A"
      condition_A :q_EMAIL_TYPE, "!=", :a_3
    end

    q_PLAN_MOVE "Do you plan on moving from your present address in the next few months?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.PLAN_MOVE"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"

    q_WHERE_MOVE "Do you know where you will be moving?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.WHERE_MOVE"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_PLAN_MOVE, "==", :a_1

    q_PLAN_MOVE_INFO "What is the address of your new home?",
    :pick => :one,
    :data_export_identifier=>"BIRTH_VISIT_2.PLAN_MOVE_INFO"
    a_1 "Address known"
    a_2 "Out of the country"
    a_3 "PO Box address only"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_WHERE_MOVE , "==", :a_1

    group "New home address" do
      dependency :rule=>"A or B"
      condition_A :q_PLAN_MOVE_INFO, "==", :a_1
      condition_B :q_PLAN_MOVE_INFO, "==", :a_3

      label "Enter address",
      :help_text => "Probe and enter as much information as participant knows."

      q_NEW_ADDRESS1_B "Address 1 - street/PO Box", :data_export_identifier=>"BIRTH_VISIT_2.NEW_ADDRESS1_B",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_ADDRESS2_B "Address 2", :data_export_identifier=>"BIRTH_VISIT_2.NEW_ADDRESS2_B",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_UNIT_B "Unit", :data_export_identifier=>"BIRTH_VISIT_2.NEW_UNIT_B",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_CITY_B "City", :data_export_identifier=>"BIRTH_VISIT_2.NEW_CITY_B",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_STATE_B "State", :display_type => :dropdown, :pick => :one,
      :data_export_identifier=>"BIRTH_VISIT_2.NEW_STATE_B"
      a_1 "AL"
      a_2 "AK"
      a_3 "AZ"
      a_4 "AR"
      a_5 "CA"
      a_6 "CO"
      a_7 "CT"
      a_8 "DE"
      a_9 "DC"
      a_10 "FL"
      a_11 "GA"
      a_12 "HI"
      a_13 "ID"
      a_14 "IL"
      a_15 "IN"
      a_16 "IA"
      a_17 "KS"
      a_18 "KY"
      a_19 "LA"
      a_20 "ME"
      a_21 "MD"
      a_22 "MA"
      a_23 "MI"
      a_24 "MN"
      a_25 "MS"
      a_26 "MO"
      a_27 "MT"
      a_28 "NE"
      a_29 "NV"
      a_30 "NH"
      a_31 "NJ"
      a_32 "NM"
      a_33 "NY"
      a_34 "NC"
      a_35 "ND"
      a_36 "OH"
      a_37 "OK"
      a_38 "OR"
      a_39 "PA"
      a_40 "RI"
      a_41 "SC"
      a_42 "SD"
      a_43 "TN"
      a_44 "TX"
      a_45 "UT"
      a_46 "VT"
      a_47 "VA"
      a_48 "WA"
      a_49 "WV"
      a_50 "WI"
      a_51 "WY"
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_ZIP_B "ZIP Code", :data_export_identifier=>"BIRTH_VISIT_2.NEW_ZIP_B",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"

      q_NEW_ZIP4_B "ZIP+4", :data_export_identifier=>"BIRTH_VISIT_2.NEW_ZIP4_B",
      :pick=>:one
      a :string
      a_neg_1 "Refused"
      a_neg_2 "Don't know"
    end

    q_WHEN_MOVE "Do you know when you will be moving?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.WHEN_MOVE"
    a_1 "Yes"
    a_2 "No"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_PLAN_MOVE, "==", :a_1

    q_DATE_MOVE "When will you move?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.DATE_MOVE"
    a_date "Date", :string, :custom_class => "date"
    a_neg_1 "Refused"
    a_neg_2 "Don't know"
    dependency :rule=>"A"
    condition_A :q_WHEN_MOVE, "==", :a_1

    q_TIME_STAMP_10 "Insert date/time stamp",
    :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_10"
    a :datetime, :custom_class => "datetime"

    label_END_OF_INTERVIEW "Thank you for participating in the National Children’s Study and for taking the time to answer our questions."
  end
  section "Interviewer-completed questions", :reference_identifier=>"Birth_INT" do
    q_TIME_STAMP_11 "Insert date/time stamp",
    :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_11"
    a :datetime, :custom_class => "datetime"

    q_PARTICIPANT "Was the interview completed with the birth mother or a proxy?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.PARTICIPANT"
    a_1 "Birth mother"
    a_2 "Proxy"

    q_CONTACT_TYPE "In what mode was the questionnaire administered?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.CONTACT_TYPE"
    a_1 "In-person"
    a_2 "Telephone"
    a_3 "Mail"
    a_4 "Web"

    q_ENGLISH "Was this data collection session conducted in english?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.ENGLISH"
    a_1 "Yes"
    a_2 "No"

    q_CONTACT_LANG "What other language was used to conduct this session?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.CONTACT_LANG"
    a_1 "Spanish"
    a_2 "Arabic"
    a_3 "Chinese"
    a_4 "French"
    a_5 "French creole"
    a_6 "German"
    a_7 "Italian"
    a_8 "Korean"
    a_9 "Polish"
    a_10 "Russian"
    a_11 "Tagalog"
    a_12 "Vietnamese"
    a_13 "Urdu"
    a_14 "Punjabi"
    a_15 "Bengali"
    a_16 "Farsi"
    a_neg_5 "Other"
    dependency :rule=>"A"
    condition_A :q_ENGLISH, "==", :a_2

    q_CONTACT_LANG_OTH "Other language",
    :data_export_identifier=>"BIRTH_VISIT_2.CONTACT_LANG_OTH"
    a "Specify", :string
    dependency :rule=>"A"
    condition_A :q_CONTACT_LANG, "==", :a_neg_5

    q_INTERPRET "Was an interpreter used?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.INTERPRET"
    a_1 "Yes"
    a_2 "No"

    q_CONTACT_INTERPRET "What type of interpreter was used?",
    :pick=>:one,
    :data_export_identifier=>"BIRTH_VISIT_2.CONTACT_INTERPRET"
    a_1 "Bilingual interviewer"
    a_2 "In-person professional interpreter"
    a_3 "In-person family member interpreter"
    a_4 "Language-line interpreter"
    a_5 "Video interpreter"
    a_6 "Sign language interpreter"
    a_neg_5 "Other"
    dependency :rule=>"A"
    condition_A :q_INTERPRET, "==", :a_1

    q_CONTACT_INTERPRET_OTH "Other type of interpreter",
    :data_export_identifier=>"BIRTH_VISIT_2.CONTACT_INTERPRET_OTH"
    a "Specify", :string
    dependency :rule=>"A"
    condition_A :q_CONTACT_INTERPRET, "==", :a_neg_5

    q_TIME_STAMP_12 "Insert date/time stamp",
    :data_export_identifier=>"BIRTH_VISIT_2.TIME_STAMP_12"
    a :datetime, :custom_class => "datetime"

    label "Explain infant and child health care log"

    label "In order to help keep track of your child’s doctor visits or other health care provider visits, we are providing
    you with an Infant and Child Health Care Log. At each Study visit or telephone interview, we will ask you about any
    health care visits your child had since the last Study visit or telephone interview. This log will help you remember
    that information. The Infant and Child Health Care Log is very similar to the Pregnancy Health Care Log, and will be used
    the same way. The only difference is the addition of the Immunization/Vaccination/Shot Log which is where all of your
    child’s vaccination information will need to be written down. It will be very helpful if you use the log to write down
    information whenever your child receives health care, so that you will be able to remember it accurately during NCS
    Study visits or telephone interviews."
  end
end