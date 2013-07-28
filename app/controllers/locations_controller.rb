class LocationsController < ApplicationController
  require 'spreadsheet'
  require 'fileutils'
  require 'iconv'

  @tmp = {}

  def search
    @locations = []
    if not params[:province].nil?
      @locations = Location.search params[:terms], params[:province]
    else
      @locations = Location.search params[:terms]
    end

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
        @locations = []

        if @filtered
          @locations = Location.where( :is_approved => 0 ).all
        else
          @locations = Location.all
        end

        @hide_map = true
      }# index.html.erb
      format.json {
        @locations = Location.where( :is_approved => true ).all

        @locations.each do |l|
          l.category = @categories.select { |cat| cat.id == l.category_id }[0]
        end

        render :json =>  @locations
      }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    @hide_map = true
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json =>  @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new
    @hide_map = true
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json =>  @location }
    end
  end

  # custom!
  def excel_import
    @hide_map = true

    if params.has_key? :dump and params[:dump].has_key? :excel_file
      @tmp = params[:dump][:excel_file].tempfile

      Spreadsheet.client_encoding = 'UTF-8'
      book = Spreadsheet.open @tmp.path
      sheet1 = book.worksheet 0
      sheet1.each_with_index do |row, i|
        # skip the first row dummy
        next if i == 0
        if ( row[3].nil? or row[3].empty? ) and ( row[5].nil? or row[5].empty? ) and
            ( row[4].nil? or row[4].empty? ) and ( row[1].nil? or row[1].empty? )
          break
        end

        cat = nil
        if not row[1].nil? and not row[1].empty?
          cat = Category.find_or_create_by_name( row[1] )
        end

        subcats = []
        if not row[2].nil? and not row[2].empty?
          subcategories = row[2].split ','
          subcategories.each do |name|
            sc = Subcategory.find_or_create_by_name name.strip
            if not cat.nil?
              sc.category = cat
              sc.save
            end
            subcats.push sc
          end
        end

        address = row[5] || ''
        newaddress = nil
        if not address.match(/^[Bb][Oo][Xx]/).nil? or not address.match(/^[Pp][Oo] [Bb][Oo][Xx]/).nil?
          newaddress = address.match(/[A-Z-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]/)
          if newaddress.nil?
            newaddress = address.match(/[0-9]{5}/)
          end
        end
        if not newaddress.nil?
          address = newaddress[0]
        end
        # do things at your leeeisurrree
        l = Location.new(:resource_type => row[0] ||= '',
                         :name => row[3] ||= '',
                         :bioregion => row[4] ||= '',
                         :address => address,
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

        if not subcats.nil?
          l.subcategory = subcats
        end

        l.save
      end
      redirect_to :locations
    end
  end

  # GET /locations/1/edit
  def edit
    @categories = Category.all
    @subcategories = @location.category.
    @locations = nil
    @hide_map = true
    if params.has_key? :id
      location = Location.find(params[:id])
      @locations = [ location ]
      @ids = [ location.id ]
    elsif params.has_key? :ids
      @ids = params[:ids].split ','
      @locations = Location.find @ids
    end
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])
    @hide_map = true
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
    @hide_map = true
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
