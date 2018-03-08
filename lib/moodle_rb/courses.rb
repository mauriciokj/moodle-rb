module MoodleRb
  class Courses
    include HTTParty
    include Utility

    attr_reader :token, :query_options

    def initialize(token, url, query_options)
      @token = token
      @query_options = query_options
      self.class.base_uri url
    end

    def index
      response = self.class.get(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_course_get_courses', token)
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response
    end

    def search(params = {})
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_course_get_courses', token),
          :body => {
            :criteria => key_value_query_format(params)
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response['courses']
    end

    # required params:
    # full_name
    # short_name
    #   must be unique
    # parent_category
    #   the parent category id inside which the new category will be created
    # optional params:
    # idnumber
    #     the new course external reference. must be unique
    def create(params)
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_course_create_courses', token),
          :body => {
            :courses => {
              '0' => {
                :fullname => params[:full_name],
                :shortname => params[:short_name],
                :categoryid => params[:parent_category],
                :idnumber => params[:idnumber],
                :startdate => params[:startdate],
                :enddate => params[:enddate]
              }
            }
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response.first
    end

    def update(params)
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_course_update_courses', token),
          :body => {
            :courses => {
              '0' => {
                :id => params[:id],
                :fullname => params[:full_name],
                :shortname => params[:short_name],
                :categoryid => params[:parent_category],
                :idnumber => params[:idnumber],
                :startdate => params[:startdate],
                :enddate => params[:enddate]
              }
            }
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response.first
    end

    def show(id)
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_course_get_courses', token),
          :body => {
            :options => {
              :ids => {
                '0' => id
              }
            }
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response.first
    end

    def destroy(id)
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_course_delete_courses', token),
          :body => {
            :courseids => {
              '0' => id
            }
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response
    end

    def enrolled_users(course_id)
      response = self.class.post(
        '/webservice/rest/server.php',
        {
          :query => query_hash('core_enrol_get_enrolled_users', token),
          :body => {
            :courseid => course_id
          }
        }.merge(query_options)
      )
      check_for_errors(response)
      response.parsed_response
    end
  end
end
