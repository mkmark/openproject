#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2022 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

module Components
  class ProjectIncludeComponent
    include Capybara::DSL
    include RSpec::Matchers

    def initialize; end

    def toggle!
      page.find("[data-qa-selector='project-include-button']").click
    end

    def expect_open
      expect(page).to have_selector("[data-qa-selector='project-include-list']")
    end

    def expect_count(count)
      expect(page).to have_selector("[data-qa-selector='project-include-button'] .badge", text: count)
    end

    def toggle_checkbox(project_id)
      page.find("[data-qa-project-include-id='#{project_id}']").click
    end

    def set_filter_selected(filter)
      within_body do
        page.find("label.spot-toggle--option", text: filter ? 'Only selected' : 'All projects').click
      end
    end

    def expect_checkbox(project_id, checked = false)
      no_loading_indicator
      page.find(
        "[data-qa-project-include-id='#{project_id}'][data-qa-project-include-checked='#{checked ? '1' : '0'}']",
        wait: 10
      )
    end

    def expect_no_checkbox(project_id)
      no_loading_indicator
      unless page.has_no_selector?("[data-qa-project-include-id='#{project_id}']")
        raise "Expected not to find #{project_id}"
      end
    end

    def search(text)
      no_loading_indicator
      within_body do
        fill_in "project-include-search",
                with: text,
                fill_options: { clear: :backspace }
      end
    end

    def expect_closed
      expect(page).to have_no_selector("[data-qa-selector='project-include-list']")
    end

    def click_button(text)
      within_body do
        page.find('button', text: text).click
      end
    end

    def within_body(&block)
      page.within(body_selector, &block)
    end

    def body_element
      page.find(selector + ' .spot-drop-modal--body')
    end

    def body_selector
      selector + ' .spot-drop-modal--body'
    end

    def selector
      '.op-project-include'
    end

    def no_loading_indicator
      expect(page).to have_no_selector("[data-qa-selector='op-project-include--loading']")
    end
  end
end
