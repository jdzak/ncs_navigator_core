class InstrumentEventMap

  # TODO: Map PSC Activities to Instrument File names !!!!

  ##
  # For a given PSC segment, return the filenames of all the Instruments/Surveys that match
  # from the MDES Instrument and Event Map
  #
  # @param [String] - the name of the PSC segment (e.g. Lo-Intensity: Pregnancy Screener)
  # @return [Array, <String>] - filenames for that event
  def self.instruments_for_segment(segment)
    return [] if segment.nil?
    event = PatientStudyCalendar.strip_epoch(segment)
    result = []
    instruments.each do |ie|
      result << ie["filename"] if ie["event"].include?(event)
    end
    result
  end

  ##
  # For a given activity from a PSC segment, return the filename of the Instrument with
  # the matching name from the MDES Instrument and Event Map
  #
  # @param [String] - the name of the PSC segment activity (e.g. Pregnancy Probability Group Follow-Up Interview)
  # @return [String] - filename for the instrument whose name matches the activity
  def self.instrument_for_activity(activity)
    result = nil
    instruments.each do |ie|
      if ie["name"].include?(activity_to_instrument_name(activity))
        result = ie["filename"]
        break
      end
    end
    result
  end

  # FIXME: PSC template activities should match MDES instruments
  def self.activity_to_instrument_name(activity)
    case activity
    when "Low-Intensity Birth Interview"
      "Birth Interview (LI)"
    else
      activity
    end
  end

  ##
  # For a given survey title (i.e. instrument filename), return the event name (i.e. the activity from a PSC segment)
  #
  # @param [String] - filename for the instrument whose name matches the activity
  # @return [String] - the name of the PSC segment activity (e.g. Pregnancy Probability Group Follow-Up Interview)
  def self.activity_for_instrument(instrument)
    result = nil
    instruments.each do |ie|
      if instrument =~ Regexp.new(ie["filename"])
        result = ie["name"]
        break
      end
    end
    result
  end

  ##
  # A list of all the known event names.
  # @return [Array, <String>]
  def self.events
    instruments.collect { |ie| ie["event"].split(";") }.flatten.collect { |e| e.strip }.uniq.sort
  end

  ##
  # Get the current version number for this Instrument from the Instrumnnt and Event Map
  # @param [String]
  # @return [String]
  def self.version(filename)
    result = nil
    instruments.each do |ie|
      if filename =~ Regexp.new(ie["filename"])
        result = ie["version_number"]
        break
      end
    end
    result
  end

  ##
  # For the given filename, find the NcsCode from the INSTRUMENT_TYPE_CL1 Code List.
  # @param [String]
  # @return [NcsCode]
  def self.instrument_type(filename)
    if filename.index(' ').to_i > 0
      sub = filename[filename.index(' '), filename.length]
      filename = filename.gsub(sub, '')
    end

    result = nil
    instruments.each do |ie|
      if ie["filename"] == filename
        result = NcsCode.where(:list_name => 'INSTRUMENT_TYPE_CL1').where(:display_text => ie["name"]).first
        break
      end
    end
    result
  end

  def self.instruments
    results = []
    with_specimens = NcsNavigatorCore.with_specimens
    INSTRUMENT_EVENT_CONFIG.each do |ie|
      filename = ie["filename"]
      next if filename.include?("_DCI_") && with_specimens == "false"

      case NcsNavigatorCore.recruitment_type
      when "HILI"
        results << ie if filename.include?("HILI") || filename.include?("HI") || filename.include?("LI")
      when "PB"
        results << ie if filename.include?("PB")
      when "EH"
        results << ie if filename.include?("EH")
      end
    end
    results
  end

end
