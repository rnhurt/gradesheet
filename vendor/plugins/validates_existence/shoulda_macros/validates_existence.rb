class Test::Unit::TestCase

  def self.should_require_existence_of(*attributes)
    options = attributes.extract_options!
    klass = model_class
    
    attributes.each do |attribute|
      should "require #{attribute} exists" do
        object = get_instance_of(klass)
        object.send("#{attribute}_id=", 0)
        assert !object.valid?, "#{object.class} was saved with a non-existent #{attribute}"
        assert object.errors.on(attribute), "There are no errors on #{attribute} after being set to a non-existent record"
        assert_contains(object.errors.on(attribute), 'does not exist', "when set to 0")
      end
    end
    
    if options[:allow_nil]
      attributes.each do |attribute|
        should "allow #{attribute} to be nil" do
          object = get_instance_of(klass)
          object.send("#{attribute}_id=", nil)
          object.valid?
          assert !object.errors.on(attribute), "There were errors on #{attribute} after being set to nil"
        end
      end
    end
  end
  
end