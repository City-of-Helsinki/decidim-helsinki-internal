# frozen_string_literal: true

require "rubyXL"

namespace :plans do
  # Export budgeting results to CSV.
  # Usage: rake plans:export_authors[1,tmp/plans.xlsx]
  desc "Export plan authors."
  task :export_authors, [:component_id, :filename] => [:environment] do |_t, args|
    component = Decidim::Component.find(args[:component_id])
    raise "Unknown component ID: #{args[:component_id]}" unless component
    raise "Please define a file name!" unless args[:filename]

    org = component.organization

    # Write to the log immidiately which would not otherwise happen when the
    # output is forwarded.
    $stdout.sync = true

    logger = Logger.new(STDOUT)
    logger.level = Logger::INFO

    # Generate the data
    data = []
    Decidim::Plans::Plan.where(component: component).published.not_hidden.except_withdrawn.each do |plan|
      plan.coauthorships.each do |coauthorship|
        data << {
          id: plan.id,
          state: plan.state,
          published_at: plan.published_at.strftime("%Y-%m-%dT%H:%M:%S%z"),
          title: plan.title[org.default_locale],
          author: author_data(coauthorship)
        }
      end
    end

    data.map! { |row| prepare_data_row(row) }

    book = RubyXL::Workbook.new
    book.worksheets.delete_at(0)

    sheet = book.add_worksheet("Data")
    data.first.keys.each_with_index do |colname, index|
      sheet.add_cell(0, index, colname.to_s)
    end
    row = 1
    data.each do |datarow|
      datarow.values.each_with_index do |val, index|
        sheet.add_cell(row, index, val)
      end
      row += 1
    end

    filename = args[:filename]

    logger.info "Writing the data document..."
    book.write(filename)

    logger.info "Data written to: #{filename}"
  end

  def prepare_data_row(rowdata)
    rowdata.each_with_object({}) do |(key, value), final|
      case value
      when Hash
        prepare_data_row(value).each do |subkey, subvalue|
          final["#{key}/#{subkey}"] = subvalue
        end
      when Array
        final[key.to_s] = value.compact.map(&:to_s).join(",")
      else
        final[key.to_s] = value
      end
    end
  end

  def author_data(coauthorship)
    author = coauthorship.identity

    if author.is_a?(Decidim::Organization)
      return {
        id: "",
        name: author.name,
        nickname: author.host,
        email: ""
      }
    end

    {
      id: author.id,
      created_at: coauthorship.created_at.strftime("%Y-%m-%dT%H:%M:%S%z"),
      name: author.name,
      nickname: author.nickname,
      email: author.email
    }
  end
end
