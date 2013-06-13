# Always work through the interface MagicAttribute.value
class MagicAttribute < ActiveRecord::Base
  attr_accessible :magic_column, :magic_option, :value
  belongs_to :magic_column
  belongs_to :magic_option

  before_save :update_magic
  
  def to_s
    (magic_option) ? magic_option.value : value
  end
  
  def update_magic
    if option = find_magic_option_for(value)
      unless magic_option and magic_option == option
        self.value = nil
        self.magic_option = option
      end
    elsif magic_column.allow_other
      self.magic_option = nil
    end
  end
  
private

  def find_magic_option_for(value)
    magic_column.magic_options.find(:first,
      :conditions => ["value = ? or synonym = ?", value, value]) unless magic_column.nil? or magic_column.magic_options.nil?
  end
end
