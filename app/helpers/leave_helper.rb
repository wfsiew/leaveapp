module LeaveHelper
  def self.get_errors(errors, attr = {})
    { :error => 1, :errors => errors }
  end
end
