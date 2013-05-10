class LocationsController < ApplicationController
  require 'spreadsheet'
  require 'fileutils'
  require 'iconv'

  @tmp = {}

  def search
    @locations = Location.search params[:terms]
    respond_to do |format|
      format.json { render :json =>  @locations }
    end
  end

  # GET /locations
  # GET /locations.json
  def index
    @categories = Category.all
    respond_to do |format|
      format.html {
        if not authenticated?
          redirect_to :root
        end

        @filtered = !params[:filtered].nil?
        puts "\n\nfiltered: #{@filtered}"
        @locations = []

        if @filtered
          puts "only getting unapproved"
          @locations = Location.where( :is_approved => 0 ).all
        else
          puts "getting all!"
          @locations = Location.all
        end

      }# index.html.erb
      format.json {
        @locations = Location.where( :is_approved => true ).all
        render :json =>  @locations
      }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json =>  @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json =>  @location }
    end
  end

  # custom!
  def excel_import
    if params.has_key? :dump and params[:dump].has_key? :excel_file
      @tmp = params[:dump][:excel_file].tempfile

      Spreadsheet.client_encoding = 'UTF-8'
      book = Spreadsheet.open @tmp.path
      sheet1 = book.worksheet 0
      sheet1.each_with_index do |row, i|
        # skip the first row dummy
        next if i == 0

        cat = nil
        if not row[1].empty?
          cat = Category.find_or_create_by_name( row[1] )
        end

        # do things at your leeeisurrree
        l = Location.new(:resource_type => row[0] ||= '',
                     :subcategory => row[2] ||= '',
                     :name => row[3] ||= '',
                     :bioregion => row[4] ||= '',
                     :address => row[5] ||= '',
                     :phone => row[6] ||= '',
                     :url => row[7] ||= '',
                     :fb_url => row[8] ||= '',
                     :twitter_url => row[9] ||= '',
                     :description => row[10] ||= '',
                     :content => row[11] ||= '',
                         :is_approved => 1 )
        if not cat.nil?
          l.category_id = cat.id
        end
        l.save
      end
      redirect_to :locations
    end
  end

  # GET /locations/1/edit
  def edit
    @categories = Category.all
    @locations = nil
    if params.has_key? :id
      location = Location.find(params[:id])
      @locations = [ location ]
    elsif params.has_key? :ids
      @ids = params[:ids].split ','
      @locations = Location.find @ids
    end
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, :notice => 'Location was successfully created.' }
        format.json { render :json =>  @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.json { render :json =>  @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @locations = []
    @errors = []
    if params.has_key? :id
      location = Location.find(params[:id])
      @locations = [ location ]
    elsif params.has_key? :locations
      params[:locations][:location].each do |data|
        l = Location.find data[0]
        if not l.update_attributes data[1]
          pp l.errors
          @errors.push l.errors
        end
        @locations.push l
      end
    end

    respond_to do |format|
      if @errors.empty?
        format.html { redirect_to :locations, :notice => 'Locations successfully updated.'}
        format.json { head :no_content }
      else
        format.html { render :action =>"edit" }
        format.json { render :json =>  @errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @locations = nil

    if params.has_key? :id
      location = Location.find params[:id]
      @locations = [ location ]
    elsif params.has_key? :ids
      @locations = Location.find params[:ids].split(",")
    end

    if not @locations.empty?
      @locations.each do |l|
        l.destroy
      end
    end

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def approve
    @locations = Location.find params[:ids].split(",")
    @locations.each do |l|
      l.is_approved = true
      l.save
    end

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end
end

# WAT
if @tmp
  FileUtils.rm @tmp.path unless nil
end
