//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery.autosize
//= require sweetalert
//= require sweet-alert-confirm
//= require clipboard
//= require_self
//= require_tree .

// Executes the given function on the specified page/pages.
// Requires body to have class '<controller> <action>'.
// The given pageSelector should have a format: '<controller> <action>'.
// Could be followed by comma and another pageSelector.
// Example: 'users show, users edit, users update, sessions new'.
function onPage(pageSelector, fun) {
  pageSelector = pageSelector.replace(/, /g, ',.')
                             .replace(/ /g, '.')
                             .replace(/^/, '.');
  $(document).on('page:change', function() {
    if ($(pageSelector).length > 0) {
      fun();
    }
  });
};

// Executes the given function on every page.
function onEveryPage(fun) {
  $(document).on('page:change', fun);
}
