module Oops
  # The snippets printed by `oops init zsh|bash|fish`, meant for
  # `eval "$(oops init zsh)"` (or `oops init fish | source`) in the rc file,
  # after whatever puts oops's Ruby on PATH and as early as possible after
  # that. The templates live in lib/oops/shell/; the absolute path of the oops
  # executable is written into them, so a later change to PATH cannot break
  # the hooks.
  module ShellInit
    SHELLS = %w[zsh bash fish].freeze
    TEMPLATE_DIR = File.expand_path("shell", __dir__)
    BIN_PLACEHOLDER = "__OOPS_BIN__".freeze

    def self.snippet(shell, bin: "oops")
      raise ArgumentError, "unsupported shell: #{shell}" unless SHELLS.include?(shell)

      template = File.read(File.join(TEMPLATE_DIR, "oops.#{shell}"), encoding: Encoding::UTF_8)
      template.gsub(BIN_PLACEHOLDER) { shell == "fish" ? fish_quote(bin) : shell_quote(bin) }
    end

    # One single-quoted word for zsh and bash: ' becomes '\''.
    def self.shell_quote(text)
      "'#{text.to_s.gsub("'") { "'\\''" }}'"
    end

    # fish single quotes take \' and \\ instead.
    def self.fish_quote(text)
      "'#{text.to_s.gsub(/[\\']/) { "\\#{_1}" }}'"
    end

    private_class_method :shell_quote, :fish_quote
  end
end
