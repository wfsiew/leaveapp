require 'digest'

class User < ActiveRecord::Base
  attr_accessible :id, :pwd, :role, :status, :username, :pwd_confirmation
  attr_accessor :pwd
  
  self.table_name = 'user'
  
  has_one :employee, :dependent => :nullify
  
  validates :username, :uniqueness => { :message => "Username %{value} already exist" },
                       :length => { :within => 3..50, :message => "Minimum is %{value} characters" }
  validates :pwd, :confirmation => { :message => "Password doesn't match confirmation" },
                  :length => { :within => 4..20, :message => "Minimum is %{value} characters" },
                  :presence => { :message => "Password is required" },
                  :if => :password_required?
                  
  before_save :encrypt_new_password
  
  UNCHANGED_PASSWORD = '********'
  
  def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.authenticated?(password)
      return username
    end
  end
  
  def authenticated?(password)
    self.password == encrypt(password)
  end
  
  protected
  
  def encrypt_new_password
    return if pwd.blank?
    self.password = encrypt(pwd)
  end
  
  def password_required?
    if pwd == UNCHANGED_PASSWORD
      return false
    end
    self.password.blank? || pwd.present?
  end
  
  def encrypt(string)
    Digest::SHA1.hexdigest(string)
  end
end
