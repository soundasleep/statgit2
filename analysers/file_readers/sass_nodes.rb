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
      LOG.warning "Raised #{e} when analysing #{file}"
      nil
    end
  end

  def import(collection)
    SassNodes.import(collection)
  end

  private

  class MySassVisitor < Sass::Tree::Visitors::Base
    attr_reader :output

    NODE_MAP = {
      Sass::Tree::Node => :nodes,

      Sass::Tree::RuleNode => :rules,       # any generic rule, e.g. `head { }`
      Sass::Tree::PropNode => :properties,  # any generic proprty e.g. `background: red;`
      Sass::Tree::ExtendNode => :extends,   # @extend
    }

    def initialize
      # @output = {
      #   # common things
      #   nodes: 0,

      #   rules: 0,
      #   properties: 0,
      #   variables: 0,
      #   comments: 0,
      #   imports: 0,       # import for SASS
      #   medias: 0,        # @media
      #   directives: 0,    # @import for plain CSS, other unprocessed CSS directives
      #   extends: 0,       # @extend
      #   mixin_definitions: 0,
      #   mixins: 0,        # a mixin include

      #   # uncommon things
      #   functions: 0,     # function definition
      #   ifs: 0,           # @if, @else, @else if
      #   fors: 0,          # @for
      #   eaches: 0,        # @each
      #   whiles: 0,        # @while
      #   others: 0,        # anything we haven't identified
      # }

      @output = Hash.new { |hash, key| hash[key] = 0 }
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
    Sass::Importers::Filesystem.new(repository.root_path)
  end
end

FILE_ANALYSERS << SassNodes
