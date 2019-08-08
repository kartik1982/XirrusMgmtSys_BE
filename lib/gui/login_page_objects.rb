module GUI
  module LoginPageObjects
    def browser
      @browser
    end
    def go(url)
      browser.goto(url)
    end

    def login_form
      browser.element(xpath: "//form[1]")
    end

    def login_form_header
      @browser.div(css: '.login_form').div(css: '.header')
    end

    def login_form_header_image
      login_form_header.style 'background-image'
    end

    def login_form_username_field
      login_form.text_field(name: "j_username")
    end

    def login_form_password_field
      login_form.text_field(name: "j_password")
    end

    def login_form_submit_btn
      @browser.button(value: "Log In")
    end
    def main_container
      browser.send(:div, {id: "main_container"})
    end
    def user_name_dropdown
      browser.send(:element, {css: "#header_nav_user xc-icon"})
    end
  end
end