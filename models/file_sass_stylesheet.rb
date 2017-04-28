class FileSassStylesheet < ActiveRecord::Base
  belongs_to :commit
  belongs_to :commit_file

  validates :nodes, :rules, :properties, :variables,
      :directives, :imports, :medias, :extends,
      :mixin_definitions, :mixins,
        presence: true,
        numericality: { only_integer: true }
end
