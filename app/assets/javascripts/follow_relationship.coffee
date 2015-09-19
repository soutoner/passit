# TODO: Remove alerts

(($) ->

  ## Parameters
  ## ----------------------------------
  # Button classes
  classes =
    default:    'btn-info',
    following:  'btn-success',
    unfollow:   'btn-danger'

  # URL using REST convention (POST-follow, DELETE-unfollow)
  urls =
    request:  '/users/follow'
    login:    '/users/sign_in'

  jQuery ->
    ## JQuery
    ## ----------------------------------
    # On click event
    $('button.followButton').click((e) ->
      e.preventDefault()
      button = $(this)

      data = 'id=' + button.attr('rel')

      if button.hasClass(classes.following) # User already followed
        unfollowRequest(button, data)
      else # User non followed
        followRequest(button, data)
    )

    # Hover event
    $('button.followButton').hover(
      ->
        button = $(this)
        if button.hasClass(classes.following)
          button.addClass(classes.unfollow)
          button.text('Unfollow')
      , ->
        button = $(this)
        if button.hasClass(classes.following)
          button.removeClass(classes.unfollow)
          button.text('Following')
    )

    ## Follow/Unfollow AJAX requests
    ## ----------------------------------
    followRequest = (button, followedId) ->
      $.ajax
        type: 'POST',
        url: urls.request,
        dataType: 'JSON',
        data: followedId,
        error: (jqXHR, textStatus, errorThrown) ->
          handleAjaxError(jqXHR, textStatus, errorThrown)
        success: (data, textStatus, jqXHR) ->
          $('a.followers').text(data['followers']);
          button.removeClass(classes.default);
          button.addClass(classes.following);
          button.text('Following');

    unfollowRequest = (button, followedId) ->
      $.ajax
        type: 'DELETE',
        url: urls.request,
        dataType: 'JSON',
        data: followedId,
        error: (jqXHR, textStatus, errorThrown) ->
         handleAjaxError(jqXHR, textStatus, errorThrown)
        success: (data, textStatus, jqXHR) ->
          $('a.followers').text(data['followers']);
          button.removeClass(classes.following);
          button.removeClass(classes.unfollow);
          button.addClass(classes.default);
          button.text('Follow');

    ## Handle AJAX ERROR
    ## ----------------------------------
    handleAjaxError = (jqXHR, textStatus, errorThrown) ->
      if jqXHR.status == 401 # Unauthorized
        window.location.replace(urls.login)
      else
        alert(textStatus)
) jQuery
