module Bim
  module IfcModels
    class RowCell < ::RowCell
      include ::IconsHelper
      include ::AvatarHelper
      include ::Redmine::I18n

      def title
        if still_processing?
          model.title
        else
          link_to model.title,
                  bcf_project_ifc_model_path(model.project, model)
        end
      end

      def default?
        if model.is_default?
          op_icon 'icon icon-checkmark'
        end
      end

      def updated_at
        format_date(model.updated_at)
      end

      def uploader
        icon = avatar model.uploader, size: :mini
        icon + model.uploader.name
      end

      def processing
        content_tag(:span) do
          content = content_tag(:span, I18n.t("ifc_models.conversion_status.#{model.conversion_status.to_s}"))
          content << content_tag(:span, model.conversion_error_message) if model.conversion_error_message
          content.html_safe
        end
      end

      def still_processing?
        model.xkt_attachment.nil?
      end

      ###

      def button_links
        if User.current.allowed_to?(:manage_ifc_models, model.project)
          [edit_link, delete_link]
        else
          []
        end
      end

      def delete_link
        link_to '',
                bcf_project_ifc_model_path(model.project, model),
                class: 'icon icon-delete',
                data: { confirm: I18n.t(:text_are_you_sure) },
                method: :delete
      end

      def edit_link
        link_to '',
                edit_bcf_project_ifc_model_path(model.project, model),
                class: 'icon icon-edit',
                accesskey: accesskey(:edit)
      end
    end
  end
end
