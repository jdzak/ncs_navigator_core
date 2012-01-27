require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do

  it "is included in the helper object" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(WelcomeHelper)
  end
  
  context "psc activities report" do
    it "organizes the activity information provided by PSC" do
      json_response = '{"rows":[{"grid_id":"9211e704-4975-48c9-91aa-6331f5899a9f", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-10-20", "ideal_date":"2011-10-20", "subject":{"grid_id":"4f8d4e85-34b0-4205-b985-501f575cad3a", "name":"Sojourner Truth", "person_id":"2d3a1470-dd80-012e-0380-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"82d8fa5f-07bc-45ec-b9dc-e8be48582175", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-10-20", "ideal_date":"2011-10-20", "subject":{"grid_id":"68b7ca7b-3a94-47cf-9661-9aaf9b8deba0", "name":"Anya Smith", "person_id":"fd1f6570-dd81-012e-038c-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"3e9c0fe4-95d1-4330-ae9e-baa456b4d138", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2012-04-20", "ideal_date":"2012-04-20", "subject":{"grid_id":"68b7ca7b-3a94-47cf-9661-9aaf9b8deba0", "name":"Anya Smith", "person_id":"fd1f6570-dd81-012e-038c-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"2f620524-92b9-4cb3-97bb-53ab02436c13", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2012-04-20", "ideal_date":"2012-04-20", "subject":{"grid_id":"68b7ca7b-3a94-47cf-9661-9aaf9b8deba0", "name":"Anya Smith", "person_id":"fd1f6570-dd81-012e-038c-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"9e58c4e7-d1fd-40d5-a308-4cfb6e700ecb", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-02", "ideal_date":"2011-11-02", "subject":{"grid_id":"f12802e4-e48d-4c8a-a199-dc6e89ac75ed", "name":"Holly Golightly", "person_id":"cbceb490-e79e-012e-a563-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"1c595c0b-3f1c-4716-8d48-261c6bf2674e", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-03", "ideal_date":"2011-11-03", "subject":{"grid_id":"95b56883-1131-4455-8a91-1c7c1772b77b", "name":"Bonnie Ocean", "person_id":"5297ad90-e867-012e-bda2-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"d8558680-3f73-4f8b-af2c-a71d43c8cb62", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2012-05-03", "ideal_date":"2012-05-03", "subject":{"grid_id":"95b56883-1131-4455-8a91-1c7c1772b77b", "name":"Bonnie Ocean", "person_id":"5297ad90-e867-012e-bda2-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"159db391-5343-44b0-9b56-144502386915", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2012-05-03", "ideal_date":"2012-05-03", "subject":{"grid_id":"95b56883-1131-4455-8a91-1c7c1772b77b", "name":"Bonnie Ocean", "person_id":"5297ad90-e867-012e-bda2-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"b67b14bd-37ff-4cec-97da-5a854e636e2a", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-08", "ideal_date":"2011-11-08", "subject":{"grid_id":"6267ddc4-9613-4ab3-9df4-bb4fc668e9bd", "name":"5599a6b0-ec56-012e-2013-58b035fb69ca", "person_id":"5599a6b0-ec56-012e-2013-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"eeedfa70-478b-4bd7-a684-751807d4c907", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"e421b2ec-759c-48d1-a5e1-6f667a7764b7", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_to_high_conversion"], "activity_name":"Low Intensity Invitation to High-Intensity Conversion Interview", "activity_type":"Instrument"}, {"grid_id":"e5bd4867-b3d5-433c-8a3d-64a20132f36c", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_visit_1"], "activity_name":"Pregnant Woman Informed Consent", "activity_type":"Consent"}, {"grid_id":"10d900c3-4b3f-4e03-a803-f019221eb69a", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_visit_1"], "activity_name":"Pregnancy Visit 1 Interview", "activity_type":"Instrument"}, {"grid_id":"ec6e9e17-0013-4ce4-91f1-5dda71b81c77", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_visit_1"], "activity_name":"Pregnancy Visit 1 Information Sheet", "activity_type":"Information Sheet"}, {"grid_id":"faa79129-d274-43cf-bf29-87f944ee69e9", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_visit_1"], "activity_name":"Pregnancy Visit 1 SAQ", "activity_type":"Instrument"}, {"grid_id":"b63b891b-c3c7-4478-bf13-fe722d0d4542", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_visit_1"], "activity_name":"Environmental Tap Water Pharmaceuticals Technician Collect Instrument", "activity_type":"Environment"}, {"grid_id":"6122effe-4913-483c-9911-31acc323536a", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_visit_1"], "activity_name":"Environmental Vacuum Bag Dust Technician Collect Instrument", "activity_type":"Environment"}, {"grid_id":"9c1aefc9-c1dd-4e75-83bd-dd418904dcf5", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_visit_1"], "activity_name":"Biospecimen Adult Urine Instrument", "activity_type":"Biospecimen"}, {"grid_id":"6ad22ea0-db52-419e-9035-c9dab5db2c6a", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_visit_1"], "activity_name":"Biospecimen Adult Blood Instrument", "activity_type":"Biospecimen"}, {"grid_id":"29f0493f-20a1-4223-bb64-bcc615470049", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_visit_1"], "activity_name":"Pregnancy Health Care Log", "activity_type":"Instrument"}, {"grid_id":"8b27959d-c084-4f90-81fa-f84de82eacce", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"9af8b1cf-5ae8-4208-befb-c0b90957c8d0", "name":"Laura Amsden", "person_id":"a82779c0-ed2c-012e-59ed-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_visit_1"], "activity_name":"Environmental Tap Water Pesticides Technician Collect Instrument", "activity_type":"Environment"}, {"grid_id":"1aeeed23-50a2-43a3-b1b6-a920156d260e", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-09", "ideal_date":"2011-11-09", "subject":{"grid_id":"4f8d4e85-34b0-4205-b985-501f575cad3a", "name":"Sojourner Truth", "person_id":"2d3a1470-dd80-012e-0380-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_birth"], "activity_name":"Low-Intensity Birth Interview", "activity_type":"Instrument"}, {"grid_id":"39e2637c-b95b-491a-acc6-5155bc7335a3", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-10", "ideal_date":"2011-11-10", "subject":{"grid_id":"fef0b0be-a011-42a3-b9c8-d932d51c2b41", "name":"Beatrice Portinari", "person_id":"0ae46610-ede4-012e-6d5f-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"f25307ca-d71e-4aa5-959e-41c811905db9", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-10", "ideal_date":"2011-11-10", "subject":{"grid_id":"fef0b0be-a011-42a3-b9c8-d932d51c2b41", "name":"Beatrice Portinari", "person_id":"0ae46610-ede4-012e-6d5f-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"06a1768b-63b1-4aea-b27b-80feeb0ca902", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-10", "ideal_date":"2011-11-10", "subject":{"grid_id":"fef0b0be-a011-42a3-b9c8-d932d51c2b41", "name":"Beatrice Portinari", "person_id":"0ae46610-ede4-012e-6d5f-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"d1e45d07-ed08-4df4-88ca-53a5ec52caf4", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-10", "ideal_date":"2011-11-10", "subject":{"grid_id":"fef0b0be-a011-42a3-b9c8-d932d51c2b41", "name":"Beatrice Portinari", "person_id":"0ae46610-ede4-012e-6d5f-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_to_high_conversion"], "activity_name":"Low Intensity Invitation to High-Intensity Conversion Interview", "activity_type":"Instrument"}, {"grid_id":"1cec604f-41e9-4402-b9b1-752a77f29d5e", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-10", "ideal_date":"2011-11-10", "subject":{"grid_id":"7f676409-4514-496f-b9a7-b55b45f0036d", "name":"asdf asdf", "person_id":"9591e6c0-edf8-012e-734a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"51b2e0c4-22de-4b91-beef-a5054fdcc568", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-10", "ideal_date":"2011-11-10", "subject":{"grid_id":"7f676409-4514-496f-b9a7-b55b45f0036d", "name":"asdf asdf", "person_id":"9591e6c0-edf8-012e-734a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"95ea8c04-f7da-4d7d-836c-d3aa4872b968", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-10", "ideal_date":"2011-11-10", "subject":{"grid_id":"7f676409-4514-496f-b9a7-b55b45f0036d", "name":"asdf asdf", "person_id":"9591e6c0-edf8-012e-734a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"9081bd88-6af6-4ce9-ad9f-5194007b3760", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-10", "ideal_date":"2011-11-10", "subject":{"grid_id":"238addcd-16fd-4c43-a47d-5f4204391a4d", "name":"Trixie Von Dee", "person_id":"2e5557d0-ee14-012e-898e-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"6935ba67-66b1-4654-9b79-01ee49e74c3c", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-10", "ideal_date":"2011-11-10", "subject":{"grid_id":"238addcd-16fd-4c43-a47d-5f4204391a4d", "name":"Trixie Von Dee", "person_id":"2e5557d0-ee14-012e-898e-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"4e5d9d4e-b4eb-4827-8adc-f76cb0bc1d30", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-10", "ideal_date":"2011-11-10", "subject":{"grid_id":"238addcd-16fd-4c43-a47d-5f4204391a4d", "name":"Trixie Von Dee", "person_id":"2e5557d0-ee14-012e-898e-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"dcbd29ae-08e8-4def-bacb-89049174cbd3", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-11", "ideal_date":"2011-11-11", "subject":{"grid_id":"6a817d0e-687d-4d93-9e3d-56150b8af7d5", "name":"23bbd470-eed1-012e-bc60-58b035fb69ca", "person_id":"23bbd470-eed1-012e-bc60-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"286d1e9e-f446-4df8-afd0-e562e6a5fc47", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-14", "ideal_date":"2011-11-14", "subject":{"grid_id":"bc1f8ae7-6e3e-42e9-9410-5bc00bf8ab21", "name":"Jane Addams", "person_id":"dce6e580-f117-012e-d572-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"cafc2827-b71a-4b7d-9764-75a9e0c8e168", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-15", "ideal_date":"2011-11-15", "subject":{"grid_id":"dee0c482-6560-4d7b-990d-a1286cd37aa0", "name":"28312480-f1d8-012e-ec6d-58b035fb69ca", "person_id":"28312480-f1d8-012e-ec6d-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"d2be40d7-356c-4bbd-a19c-a3ab5831d6f7", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-15", "ideal_date":"2011-11-15", "subject":{"grid_id":"eb2f7000-93ca-4eb5-8cb1-d8f7254ab79c", "name":"729dc520-f1d8-012e-ec75-58b035fb69ca", "person_id":"729dc520-f1d8-012e-ec75-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"f0335b72-e264-4fc9-9287-f123fb3127b6", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-15", "ideal_date":"2011-11-15", "subject":{"grid_id":"3560e0bf-f75f-48d1-801c-bcc937884037", "name":"f60b4230-f1d8-012e-ec7d-58b035fb69ca", "person_id":"f60b4230-f1d8-012e-ec7d-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"c19f4f98-f156-4756-8527-4bac3fcc2f80", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-15", "ideal_date":"2011-11-15", "subject":{"grid_id":"d27b74a8-e3e3-4b80-9202-8f75fd113725", "name":"5498a5a0-f1e0-012e-eea8-58b035fb69ca", "person_id":"5498a5a0-f1e0-012e-eea8-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"bd21ae98-042a-4fdf-b42e-6df520ce0c3a", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-30", "ideal_date":"2011-11-30", "subject":{"grid_id":"bc618767-a9b0-4c4b-b22e-d280aacc1f87", "name":"Jane Addams", "person_id":"c31b2720-f1f4-012e-f611-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pre-pregnancy"], "activity_name":"Non-Pregnant Woman Informed Consent", "activity_type":"Consent"}, {"grid_id":"37b69d64-8789-4f56-85ed-f3e589e27ab2", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-30", "ideal_date":"2011-11-30", "subject":{"grid_id":"bc618767-a9b0-4c4b-b22e-d280aacc1f87", "name":"Jane Addams", "person_id":"c31b2720-f1f4-012e-f611-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pre-pregnancy"], "activity_name":"Pre-Pregnancy Visit Information Sheet", "activity_type":"Information Sheet"}, {"grid_id":"62af4bdc-9a30-48c1-9ba6-1fb3782fb625", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-30", "ideal_date":"2011-11-30", "subject":{"grid_id":"bc618767-a9b0-4c4b-b22e-d280aacc1f87", "name":"Jane Addams", "person_id":"c31b2720-f1f4-012e-f611-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pre-pregnancy"], "activity_name":"Pre-Pregnancy SAQ", "activity_type":"Instrument"}, {"grid_id":"ce736652-7fa0-4f87-8792-548fc7f8e4ca", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-17", "ideal_date":"2011-11-17", "subject":{"grid_id":"10284845-78b7-4b23-b629-934c4583307d", "name":"Bunny Holiday", "person_id":"cf9b8c00-f366-012e-0275-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"63cd10e3-6a58-4a94-9b33-d2117c566324", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-17", "ideal_date":"2011-11-17", "subject":{"grid_id":"10284845-78b7-4b23-b629-934c4583307d", "name":"Bunny Holiday", "person_id":"cf9b8c00-f366-012e-0275-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"67a58de9-4e30-40f1-9fb4-9746f194a27b", "last_change_reason":"", "study":"NCS Hi-Lo", "scheduled_date":"2012-03-15", "ideal_date":"2012-05-29", "subject":{"grid_id":"8ffd986f-e486-4fcc-ab39-db3c489f8414", "name":"Bessie Smith", "person_id":"dc6a2ed0-f68b-012e-3113-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_birth"], "activity_name":"Low-Intensity Birth Interview", "activity_type":"Instrument"}, {"grid_id":"9342edad-b2e0-48c1-85b2-6e379c6442b8", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2012-03-01", "ideal_date":"2012-03-01", "subject":{"grid_id":"9c083805-e764-4a10-a84e-c1b51b82db4f", "name":"Ma Rainey", "person_id":"733d26b0-f690-012e-3141-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_birth"], "activity_name":"Low-Intensity Birth Interview", "activity_type":"Instrument"}, {"grid_id":"ea0dc2f8-e8d8-41a6-8a90-eb1fc993843b", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-11-29", "ideal_date":"2011-11-29", "subject":{"grid_id":"3f65d577-f010-449a-beaa-fe767f1b6a4d", "name":"Jill Pill", "person_id":"d1800650-fcd0-012e-2ce9-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"129df062-fb89-4ba3-a9d5-1c053a541fba", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-02", "ideal_date":"2011-12-02", "subject":{"grid_id":"26d689ba-3dbb-40bd-b580-55f5809f2a8f", "name":"Edwina Robinson", "person_id":"66af8380-ff37-012e-8457-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"d3cc516b-3c72-4f4a-86d6-90a2db6fcefd", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-02", "ideal_date":"2011-12-02", "subject":{"grid_id":"26d689ba-3dbb-40bd-b580-55f5809f2a8f", "name":"Edwina Robinson", "person_id":"66af8380-ff37-012e-8457-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"81c95de5-56a7-4e74-ab12-7bb436d43ec5", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-05", "ideal_date":"2011-12-05", "subject":{"grid_id":"a247c87a-1d5a-4ea1-9922-89f3e434741c", "name":"Kirsten MacDonald", "person_id":"1242f280-01a0-012f-c10a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"258fe91b-30a9-4d90-b4df-157c8b746299", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-05", "ideal_date":"2011-12-05", "subject":{"grid_id":"a247c87a-1d5a-4ea1-9922-89f3e434741c", "name":"Kirsten MacDonald", "person_id":"1242f280-01a0-012f-c10a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"a638e65d-6b43-430b-8198-57179c1f4371", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-05", "ideal_date":"2011-12-05", "subject":{"grid_id":"a247c87a-1d5a-4ea1-9922-89f3e434741c", "name":"Kirsten MacDonald", "person_id":"1242f280-01a0-012f-c10a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"80e5e439-9c45-43da-a70a-b9b731cd46f2", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-05", "ideal_date":"2011-12-05", "subject":{"grid_id":"a247c87a-1d5a-4ea1-9922-89f3e434741c", "name":"Kirsten MacDonald", "person_id":"1242f280-01a0-012f-c10a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"1694a059-49f8-473b-b3f4-d5f357a8a560", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-05", "ideal_date":"2011-12-05", "subject":{"grid_id":"a247c87a-1d5a-4ea1-9922-89f3e434741c", "name":"Kirsten MacDonald", "person_id":"1242f280-01a0-012f-c10a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"1ac36409-6190-4fd1-a0cc-44820a0d5922", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-05", "ideal_date":"2011-12-05", "subject":{"grid_id":"a247c87a-1d5a-4ea1-9922-89f3e434741c", "name":"Kirsten MacDonald", "person_id":"1242f280-01a0-012f-c10a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"f0e07c4f-4756-456b-ab56-5dd0fb776558", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-05", "ideal_date":"2011-12-05", "subject":{"grid_id":"a247c87a-1d5a-4ea1-9922-89f3e434741c", "name":"Kirsten MacDonald", "person_id":"1242f280-01a0-012f-c10a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"45e31240-be34-48ca-97a1-570dc1fdf941", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-05", "ideal_date":"2011-12-05", "subject":{"grid_id":"a247c87a-1d5a-4ea1-9922-89f3e434741c", "name":"Kirsten MacDonald", "person_id":"1242f280-01a0-012f-c10a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}, {"grid_id":"b4bf45e9-2fc2-4c78-be2b-b78d89236351", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-05", "ideal_date":"2011-12-05", "subject":{"grid_id":"a247c87a-1d5a-4ea1-9922-89f3e434741c", "name":"Kirsten MacDonald", "person_id":"1242f280-01a0-012f-c10a-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"7f1f5706-0a32-4e7f-b8f9-6bc0ecd46d9d", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-06", "ideal_date":"2011-12-06", "subject":{"grid_id":"45d2e146-2a80-4ef4-b33e-e85cf6e4d9aa", "name":"522d11a0-0255-012f-db90-58b035fb69ca", "person_id":"522d11a0-0255-012f-db90-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["pregnancy_screener"], "activity_name":"Pregnancy Screener Interview", "activity_type":"Instrument"}, {"grid_id":"740f6c72-18fc-40df-813b-6f2802ff0587", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-06", "ideal_date":"2011-12-06", "subject":{"grid_id":"de537528-9a4e-48a2-9279-b327dd46195d", "name":"Jocelyn Goldsmith", "person_id":"649a7720-025a-012f-db97-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Consent", "activity_type":"Consent"}, {"grid_id":"e982065d-b787-4462-90a3-3305434d9a26", "last_change_reason":"Initialized from template", "study":"NCS Hi-Lo", "scheduled_date":"2011-12-06", "ideal_date":"2011-12-06", "subject":{"grid_id":"de537528-9a4e-48a2-9279-b327dd46195d", "name":"Jocelyn Goldsmith", "person_id":"649a7720-025a-012f-db97-58b035fb69ca"}, "activity_status":"Scheduled", "site":"Greater Chicago Study Center", "responsible_user":"pfr957", "labels":["low_intensity_data_collection"], "activity_name":"Low-Intensity Interview", "activity_type":"Instrument"}], "filters":{"states":["Scheduled"], "responsible_user":"pfr957", "end_date":"2012-05-07"}}'
      json = ActiveSupport::JSON.decode(json_response)
      
      rows = json["rows"]
      rows.should_not be_nil
      rows.size.should == 60
      
      activities = helper.activities(json_response)
      activities["dates"].size.should == 19
    end
  end

end