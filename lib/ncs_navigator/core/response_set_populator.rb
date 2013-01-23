# -*- coding: utf-8 -*-

require 'ncs_navigator/core'

module NcsNavigator::Core::ResponseSetPopulator
  autoload :Base,                     'ncs_navigator/core/response_set_populator/base'
  autoload :ParticipantVerification,  'ncs_navigator/core/response_set_populator/participant_verification'
  autoload :PbsEligibilityScreener,   'ncs_navigator/core/response_set_populator/pbs_eligibility_screener'
  autoload :PregnancyScreener,        'ncs_navigator/core/response_set_populator/pregnancy_screener'
  autoload :PregnancyVisit,           'ncs_navigator/core/response_set_populator/pregnancy_visit'
  autoload :TracingModule,            'ncs_navigator/core/response_set_populator/tracing_module'
  autoload :LowIntensity,             'ncs_navigator/core/response_set_populator/low_intensity'
  autoload :Birth,                    'ncs_navigator/core/response_set_populator/birth'
  autoload :NonInterview,             'ncs_navigator/core/response_set_populator/noninterview'
  autoload :ChildPM,                  'ncs_navigator/core/response_set_populator/child_pm'

  POPULATORS = [
    [/_ParticipantVerif_/,  ParticipantVerification],
    [/_Tracing_/,           TracingModule],
    [/_PBSamplingScreen_/,  PbsEligibilityScreener],
    [/_PregScreen_/,        PregnancyScreener],
    [/_QUE_LI/,             LowIntensity],
    [/_Birth_/,             Birth],
    [/_PregVisit1_/,        PregnancyVisit],
    [/_PregVisit2_/,        PregnancyVisit],
    [/_NonIntRespQues_/,    NonInterview],
    [/_PM_Child/,           ChildPM],
  ]

end
