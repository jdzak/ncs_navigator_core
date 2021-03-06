class AllPsuCodesToIntegersAgain < ActiveRecord::Migration
  AFFECTED_TABLES = %w(
    sampled_persons_ineligibilities institution_person_links institutions
  )

  def up
    AFFECTED_TABLES.each do |t|
      execute("ALTER TABLE #{t} ALTER COLUMN psu_code TYPE INTEGER USING psu_code::integer")
    end
  end

  def down
    AFFECTED_TABLES.reverse.each do |t|
      execute("ALTER TABLE #{t} ALTER COLUMN psu_code TYPE VARCHAR(36)")
    end
  end
end
