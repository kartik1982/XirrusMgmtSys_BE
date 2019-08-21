def goto_mynetwork
  @ui.goto_mynetwork()
end

def goto_mynetwork_arrays_tab
  goto_mynetwork
  sleep 4
  tab = @ui.id("mynetwork_tab_arrays")
  tab.wait_until_present
  sleep 2
  tab.click
  sleep 1
end

def optimize_btn
   @ui.id("arrays_optimize_button_btn")
end

def click_optimize_btn
 optimize_btn.wait_until_present
 optimize_btn.click
end

def optimize_nav
  @ui.ul(css: ".opt_menu.drop_menu_nav")
end


def wait_for_optimize_nav
   @ui.ul(css: ".opt_menu.drop_menu_nav.active").wait_until_present
end

def optimize_nav_optimize_btn
  @ui.id("mynetwork_arrays_optimize")
end



def mynetwork_select_optimize_nav_option(name)
  @ui.id("arrays_optimization_chk_#{name}").parent.label.wait_until_present
  @ui.id("arrays_optimization_chk_#{name}").parent.label.click
end

def optimize_confirm_modal
  @browser.div(css: ".optimizeprompt.modal")
end

def optimize_now_btn
  @ui.a(text: "Optimize Now")
end

def cancel_btn
  @ui.div(id: "confirmButtons").wait_until_present
  @ui.div(id: "confirmButtons").links[0]
end

# returns optimize modal
# serial = array serial
# options is array with one or more of the following ["channels", "power", band"]
def start_optimize(options) 

  #  row = @ui.array_grid.row(serial)

  #  row.select

    click_optimize_btn

    wait_for_optimize_nav

    options.each do |o|

      mynetwork_select_optimize_nav_option(o)

    end

    optimize_nav_optimize_btn.wait_until_present
    optimize_nav_optimize_btn.click

    sleep 2
    
    optimize_confirm_modal.wait_until_present   
    optimize_confirm_modal
end






def finish_optimize

  expect_no_error
  expect(optimize_confirm_modal.present?).to eql(true)
  optimize_now_btn.wait_until_present
  optimize_now_btn.click

end


def cancel_optimize
  expect(optimize_confirm_modal.present?).to eql(true)
  cancel_btn.wait_until_present
  cancel_btn.click
end
