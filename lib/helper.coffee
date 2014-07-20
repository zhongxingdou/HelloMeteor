Keycode =
	ENTER: 13
	ESCAPE: 27

@OkCancelEvents = (selector, callbacks) ->
	ok = callbacks.ok || ->
	cancel = callbacks.cancel || ->

	events = {}
	evtName = 'keyup ' + selector + ', keydown ' + selector + ', focusout ' + selector
	events[evtName] = (evt) ->
		if evt.type is "keydown" && evt.which == Keycode.ESCAPE  #escape
	        cancel.call(this, evt)
	    else if evt.type is "keyup" and evt.which == Keycode.ENTER or evt.type is "focusout" # blur/return/enter = ok/submit if non-empty
	    	value = String(evt.target.value || "")
	    	if value
	    		ok.call(this, value, evt)
	    	else
	    		cancel.call(this, evt)
	return events

@ActivateInput = (input) ->
	input.focus()
	input.select()
