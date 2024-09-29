unless Rails.env.test?
  AUDIT_DB = YAML.load_file(
    File.join(Rails.root, "config", "audited.yml")
  )[Rails.env.to_s]

  # Configure Audited to read/write to second database
  Audited::Audit.class_eval do
    establish_connection AUDIT_DB
  end
end