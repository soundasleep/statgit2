class SassNodes < AbstractFileAnalyser
  def needs_update?
    commit.file_sass_stylesheets.empty?
  end

  def extension
    "scss"
  end

  def analyse(file, string)
    begin
      parser = Sass::SCSS::Parser.new(string, file, importer)
      root = parser.parse

      output = MySassVisitor.visit(root)

      params = {
        commit: commit,
        commit_file: file,
      }.merge(output)

      FileSassStylesheet.new(params)
    rescue Sass::SyntaxError => e
      LOG.warn "Raised #{e} when analysing #{file}"
      nil
    end
  end

  def import!(collection)
    FileSassStylesheet.import!(collection)
  end

  private

  class MySassVisitor < Sass::Tree::Visitors::Base
    attr_reader :output

    NODE_MAP = {
      Sass::Tree::Node => :nodes,

      Sass::Tree::RuleNode => :rules,           # `head { }`
      Sass::Tree::PropNode => :properties,      # `background: red;`
      Sass::Tree::VariableNode => :variables,   # `$foo: black;`
      Sass::Tree::CommentNode => :comments,     # `/* comment */`

      Sass::Tree::DirectiveNode => :directives, # @import, @media, etc
      Sass::Tree::CssImportNode => :imports,    # @import
      Sass::Tree::MediaNode => :medias,         # @media

      Sass::Tree::ExtendNode => :extends,       # @extend
      Sass::Tree::MixinDefNode => :mixin_definitions,   # @mixin { }
      Sass::Tree::MixinNode => :mixins,         # @include mixin
    }

    def initialize
      @output = Hash[NODE_MAP.values.map { |key| [key, 0] }]
    end

    def visit(node)
      NODE_MAP.each do |node_type, key|
        if node.is_a?(node_type)
          output[key] += 1
        end
      end

      visit_children(node)

      output
    end
  end

  def importer
    Sass::Importers::Filesystem.new(root_path)
  end
end
