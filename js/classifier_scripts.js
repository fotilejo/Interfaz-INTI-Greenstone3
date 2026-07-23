var inProgress = new Array();
var openClassifiers = new Array();
var busy = false;

function setToggleState(sectionToggle, state)
{
	sectionToggle.removeClass("is-open is-loading");
	var icon = sectionToggle.find("i");
	icon.removeClass("fa-chevron-right fa-spinner fa-spin");
	if(state == "collapse")
	{
		sectionToggle.addClass("is-open");
		icon.addClass("fa-chevron-right");
	}
	else if(state == "loading")
	{
		sectionToggle.addClass("is-loading");
		icon.addClass("fa-spinner fa-spin");
	}
	else
	{
		icon.addClass("fa-chevron-right");
	}
}

function isExpanded(sectionID)
{
	var divElem = getAnimationSection(sectionID);
	if(!divElem.css("display") || divElem.css("display") != "none")
	{
		return true;
	}
	return false;
}

function getAnimationSection(sectionID)
{
	var wrapper = gs.jqGet("wrap" + sectionID);
	if(wrapper.length)
	{
		return wrapper;
	}

	var section = gs.jqGet("div" + sectionID);

	if(section.length && section.is("table.childrenlist"))
	{
		wrapper = $("<div>")
			.attr("id", "wrap" + sectionID)
			.addClass("gs-classifier-children");

		section.before(wrapper);
		wrapper.append(section);
		return wrapper;
	}

	return section;
}

function createClassifierEditorialLine(value)
{
	value = $.trim(value || "");
	if(!value || value.match(/^materias\s*:/i))
	{
		return null;
	}

	var parts = value.split(";");
	var publisher = "";
	var date = value;

	if(parts.length > 1)
	{
		date = $.trim(parts.pop());
		publisher = $.trim(parts.join("; "));
	}

	if(!date)
	{
		return null;
	}

	var line = $("<span>").addClass("repo-editorial-line repo-listing-editorial");
	line.append($("<span>").addClass("repo-meta-label").html('<i class="fa-solid fa-calendar-days"> </i> Edici&oacute;n'));
	var values = $("<span>").addClass("repo-field-values");

	if(publisher && !publisher.match(/^s\.?\s*n\.?$/i))
	{
		values.append($("<span>").addClass("repo-editorial-publisher").text(publisher));
		values.append($("<span>").addClass("repo-meta-separator").text("|"));
	}

	values.append($("<span>").addClass("repo-editorial-year").text(date));
	line.append(values);
	return line;
}

function modernizeClassifierEditorial(root)
{
	var scope = root && root.jquery ? root : $(root);
	scope.find("td").each(function()
	{
		var cell = $(this);
		if(cell.find(".repo-listing-editorial").length)
		{
			return;
		}

		var rule = cell.children("hr").first();
		if(!rule.length)
		{
			return;
		}

		var node = rule[0].previousSibling;
		while(node && ((node.nodeType == 3 && !$.trim(node.nodeValue)) || (node.nodeType == 1 && node.nodeName == "BR")))
		{
			node = node.previousSibling;
		}

		if(!node || node.nodeType != 3)
		{
			return;
		}

		var line = createClassifierEditorialLine(node.nodeValue);
		if(!line)
		{
			return;
		}

		$(node).replaceWith(line);

		var previous = line[0].previousSibling;
		if(previous && previous.nodeType == 1 && previous.nodeName == "BR")
		{
			$(previous).remove();
		}

		var next = rule[0].nextSibling;
		if(next && next.nodeType == 1 && next.nodeName == "BR")
		{
			$(next).remove();
		}
		rule.remove();
	});
}

function toggleSection(sectionID)
{
	var section = getAnimationSection(sectionID);
	var sectionToggle = gs.jqGet("toggle" + sectionID);
	
	if(sectionToggle == undefined)
	{
		return;
	}
	
	//If the div exists
	if(section.length)
	{
		if(isExpanded(sectionID))
		{
			setToggleState(sectionToggle, "expand");

			if(openClassifiers[sectionID] != undefined)
			{
				delete openClassifiers[sectionID];
			}
			section.stop(true, false).slideUp(220);
		}
		else
		{
			setToggleState(sectionToggle, "collapse");
			openClassifiers[sectionID] = true;	
			modernizeClassifierEditorial(section);
			section.stop(true, false).slideDown(220);
		}
		updateOpenClassifiers();
	}
	else
	{
		httpRequest(sectionID);
	}
}

function updateOpenClassifiers()
{
	var oc = "";
	var first = true;
	for(var key in openClassifiers)
	{
		if(first)
		{
			first = false;
		}
		else
		{
			oc += ",";
		}
		
		oc += key;
	}
	
	if(oc != undefined)
	{
		if(history && history.replaceState)
		{
			var newUrl = window.location.pathname + window.location.search + (oc ? "#" + oc : "");
			history.replaceState(null, null, newUrl);
		}
		else
		{
			window.location.hash = oc;
		}
	}
}

function openStoredClassifiers()
{
	if(window.location.hash != undefined && window.location.hash.length > 1)
	{
		var toOpen = window.location.hash.substring(1,window.location.hash.length).split(",");
		var loopFunction = function(sectionArray, index)
		{
			if(!busy && index < sectionArray.length)
			{
				busy = true;
				toggleSection(sectionArray[index]);
				setTimeout(function()
				{
					loopFunction(sectionArray, index + 1);
				}, 25);
				
				return true;
			}
			
			setTimeout(function()
			{
				loopFunction(sectionArray, index);
			}, 25);
			return false;
		}
		
		if(toOpen.length > 0)
		{
			loopFunction(toOpen, 0);
		}
	}
}

function httpRequest(sectionID)
{
	if(!inProgress[sectionID])
	{
		inProgress[sectionID] = true;
		var httpRequest = new gs.functions.ajaxRequest();
		
		var sectionToggle = gs.jqGet("toggle" + sectionID);
		setToggleState(sectionToggle, "loading");
		
		var url = gs.xsltParams.library_name + "/collection/" + gs.cgiParams.c + "/browse/" + sectionID.replace(/\./g, "/") + "?excerptid=div" + sectionID;

		if(gs.cgiParams.berrybasket == "on")
		{
			url = url + "&berrybasket=on";
		} 

		if(url.indexOf("#") != -1)
		{
			url = url.substring(0, url.indexOf("#"));
		}
		
		$.ajax(url)
		.success(function(data)
		{
			var newDiv = $("<div>")
				.attr("id", "wrap" + sectionID)
				.addClass("gs-classifier-children");
			var sibling = gs.jqGet("title" + sectionID);
			sibling.after(newDiv);
			
			newDiv.html(data);
			modernizeClassifierEditorial(newDiv);
			newDiv.hide().slideDown(220);
			if(window.repoModernEnhance)
			{
				window.repoModernEnhance();
				window.setTimeout(window.repoModernEnhance, 80);
			}
			setToggleState(sectionToggle, "collapse");
			openClassifiers[sectionID] = true;	
			
			if(gs.cgiParams.berrybasket == "on")
			{
				checkout();
			}
			else if(gs.cgiParams.documentbasket == "on")
			{
				dmcheckout();
			}
			updateOpenClassifiers();
		})
		.error(function()
		{
			setToggleState(sectionToggle, "expand");
		})
		.complete(function()
		{
			inProgress[sectionID] = false;
			busy = false;
		});
	}
}
