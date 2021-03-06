module Ryakuzu
  class TablesController < RootController
    def create
      result = Ryakuzu::MigrationService.new(params[:table]).call
      responds_to(result)
    end

    def column
      @column = params[:column]
      @table  = params[:table]
      @opts   = Ryakuzu::ColumnInfo.new.call(@table, @column)
      responds_to(@opts)
    end

    def column_options
      result = Ryakuzu::ColumnDefaultService.new(params[:column_defaults]).call
      responds_to(result)
    end

    def remove_column
      result = Ryakuzu::RemoveService.new(table: params[:table], column: params[:column]).call
      responds_to(result)
    end

    def remove_table
      result = Ryakuzu::RemoveService.new(table: params[:table]).call
      redirect_to :back, notice: result
    end

    def add_column_form
      @table = params[:table]
      responds_to(@table)
    end

    def add_column
      result = Ryakuzu::AddColumnService.new(params[:table], params[:name]['column'], params[:type]).call
      responds_to(result)
    end

    def add_table;  end

    def new_column; end

    def save_csv
      schema = Ryakuzu::SchemaService.new
      schema.schema_to_csv
      File.open('schema.csv', 'r') { |f| send_data f.read, type: 'text/csv', filename: 'schema.csv' }
      File.delete('schema.csv')
    end

    def create_table
      result = Ryakuzu::CreateTableService.new(params[:table], params[:column], params[:type]).call
      responds_to(result)
    end

    private

    def responds_to(variable)
      respond_to do |format|
        format.html
        format.js { variable }
      end
    end
  end
end
