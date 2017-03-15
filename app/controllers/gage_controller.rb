class GageController < ApplicationController
  unloadable
  # プロジェクトの選択
  before_filter :find_project 
  # 閲覧権限があるユーザだけ実行
  before_filter :authorize, only: :index
  
  # プラグインのトップページ
  def index
    path = ""
	textMonth = ""
	flm_selected_0 = ""
	flm_selected_1 = ""
	flm_selected_2 = ""
	flm_selected_d = ""
	flh_selected_6 = ""
	flh_selected_7 = ""
	flh_selected_8 = ""
	flh_selected_d = ""
	
	if params[:flagMonth].blank? 
		flm = 1
	else
		flm = params[:flagMonth].to_i 
		path = "../"
	end
 
 	if params[:flagHour].blank? 
		flh = 7
	else
		flh = params[:flagHour].to_i
		path = "../../"
	end
	
	case flm
		when 0 then
			textMonth = I18n.t "last_month" #"先月"
			flm_selected_0 = "selected"
		when 1 then
			textMonth = I18n.t "this_month" #"今月"
			flm_selected_1 = "selected"
		when 2 then
			textMonth = I18n.t "next_month" #"来月"
			flm_selected_2 = "selected"
		else
			flm_selected_d = "selected"
			if flm < 0
				flm2=flm-1
				flm2=flm2.abs
				textMonth = flm2.to_s << I18n.t("months_ago") #"ヶ月前"
			else
				flm2=flm-1
				textMonth = flm2.to_s << I18n.t("months_later") #"ヶ月後"
			end
	end
	
	case flh
		when 6 then
			flh_selected_6 = "selected"
		when 7 then
			flh_selected_7 = "selected"
		when 8 then
			flh_selected_8 = "selected"
		else
			flh_selected_d = "selected"
	end
	
    @user = Hash.new
	@user[:flagMonth]	= flm
	@user[:flagHour]	= flh
	@user[:path]		= path
	@user[:textMonth]	= textMonth
	@user[:flm_selected_0]	= flm_selected_0
	@user[:flm_selected_1]	= flm_selected_1
	@user[:flm_selected_2]	= flm_selected_2
	@user[:flm_selected_d]	= flm_selected_d
	@user[:flh_selected_6]	= flh_selected_6
	@user[:flh_selected_7]	= flh_selected_7
	@user[:flh_selected_8]	= flh_selected_8
	@user[:flh_selected_d]	= flh_selected_d
	
  end

  # チケットのjsonデータ
  def list
    issues = convert_issues(Issue.where(project_id: "#{@project.id}"))
    render json: issues
  end
  
  # チケットのjsonデータ月絞込
  def data
	if params[:flagMonth].blank? 
		flm = 0
	else
		flm = params[:flagMonth].to_i 
	end
	
	flm = flm - 1
	
    from = Time.now.at_beginning_of_month + flm.month
    to   = from + 1.month

    issues = convert2issues(Issue.where(project_id: "#{@project.id}").where(start_date: from...to))
    render json: issues
  end

  private

  # チケットのデータ変換
  def convert_issues(org_issues)
    issues = []
    org_issues.each { |org_issue|
      tracker  = org_issue.tracker.nil? ? nil : org_issue.tracker.name
      category = org_issue.category.nil? ? nil : org_issue.category.name
      status   = org_issue.status.nil? ? nil : org_issue.status.name
      priority = org_issue.priority.nil? ? nil : org_issue.priority.name
      assignee = org_issue.assigned_to.nil? ? nil : org_issue.assigned_to.name
      author   = org_issue.author.nil? ? nil : org_issue.author.name

      issue = {
        tracker:  tracker,
        category: category,
        status:   status,
        priority: priority,
        assignee: assignee,
        author:   author
      }

      issues.push(issue)
    }
    return issues
  end
  
  # チケットのデータ変換
  def convert2issues(org_issues)
    issues = []
    org_issues.each { |org_issue|
      assignee = org_issue.assigned_to.nil? ? nil : org_issue.assigned_to.name
	  estimated_hours = org_issue.estimated_hours
	  spent_hours = org_issue.spent_hours 
	  start_date = org_issue.start_date
	  due_date = org_issue.due_date

      issue = {
        assignee: assignee,
		estimated_hours: estimated_hours,
		spent_hours: spent_hours,
		start_date: start_date,
		due_date: due_date
      }

      issues.push(issue)
    }
    return issues
  end
  
  # 文字列を日付に変換
  def custom_parse(str)
    date = nil
    if str && !str.empty? #if str.present?
      begin
        date = DateTime.parse(str).to_s
      # parseで処理しきれない場合
      rescue ArgumentError
        formats = ['%Y:%m:%d %H:%M:%S','%Y-%m-%d'] # 他の形式が必要になったら、この配列に追加
        formats.each do |format|
          begin
            date = DateTime.strptime(str, format)
            break
          rescue ArgumentError
          end
        end
      end
    end
    return date
  end 
  
  # プロジェクトの選択
  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
end
