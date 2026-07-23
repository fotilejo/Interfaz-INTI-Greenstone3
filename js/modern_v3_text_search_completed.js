(function () {
  "use strict";

  function collectionSearchUrl(value) {
    var match = window.location.pathname.match(/\/collection\/([^/]+)/);
    if (!match) {
      var m = window.location.pathname.match(/^(\/[^/]+\/library)/);
      var lib = m ? m[1] : "?";
      return lib + "?a=q&s=TextQuery&qs=1&rt=rd&s1.query=" + encodeURIComponent(value);
    }
    var library = window.location.pathname.split("/collection/")[0];
    return library + "/collection/" + match[1] + "/search/TextQuery?qs=1&rt=rd&s1.query=" + encodeURIComponent(value);
  }

  function showToast(message) {
    var toast = document.querySelector(".repo-toast");
    if (!toast) {
      toast = document.createElement("div");
      toast.className = "repo-toast";
      document.body.appendChild(toast);
    }
    toast.textContent = message;
    toast.classList.add("is-visible");
    window.clearTimeout(showToast.timer);
    showToast.timer = window.setTimeout(function () {
      toast.classList.remove("is-visible");
    }, 2400);
  }

  function copyWithTextArea(value) {
    var input = document.createElement("textarea");
    input.value = value;
    document.body.appendChild(input);
    input.select();
    document.execCommand("copy");
    input.remove();
    showToast("Enlace copiado");
  }

  function copyCurrentUrl() {
    var value = window.location.href;
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(value).then(function () {
        showToast("Enlace copiado");
      }).catch(function () {
        copyWithTextArea(value);
      });
      return;
    }
    copyWithTextArea(value);
  }

  function enhanceToggleIcons() {
    document.querySelectorAll("img.turnstyleicon:not([data-modernized])").forEach(function (image) {
      image.dataset.modernized = "true";
      image.classList.add("legacy-resource-icon");
      var button = document.createElement("button");
      button.type = "button";
      button.className = "gs-toggle-button";
      button.setAttribute("aria-label", "Desplegar o contraer");
      button.innerHTML = '<i class="fa-solid fa-chevron-right"></i>';
      button.addEventListener("click", function (event) {
        event.preventDefault();
        image.click();
        button.classList.toggle("is-open");
      });
      image.insertAdjacentElement("afterend", button);
    });
  }

  function enhanceNavigation() {
    document.querySelectorAll(".nav-dropdown-toggle:not([data-modernized])").forEach(function (toggle) {
      toggle.dataset.modernized = "true";
      toggle.addEventListener("click", function (event) {
        event.preventDefault();
        event.stopPropagation();
        var item = toggle.closest(".nav-has-submenu");
        var willOpen = !item.classList.contains("is-open");
        document.querySelectorAll(".nav-has-submenu.is-open").forEach(function (openItem) {
          openItem.classList.remove("is-open");
          var openToggle = openItem.querySelector(".nav-dropdown-toggle");
          if (openToggle) openToggle.setAttribute("aria-expanded", "false");
        });
        item.classList.toggle("is-open", willOpen);
        toggle.setAttribute("aria-expanded", willOpen ? "true" : "false");
      });
    });
    if (document.documentElement.dataset.repoNavigationReady) return;
    document.documentElement.dataset.repoNavigationReady = "true";
    document.addEventListener("click", function () {
      document.querySelectorAll(".nav-has-submenu.is-open").forEach(function (item) {
        item.classList.remove("is-open");
        var toggle = item.querySelector(".nav-dropdown-toggle");
        if (toggle) toggle.setAttribute("aria-expanded", "false");
      });
    });
    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape") document.body.click();
    });
  }

  function removeDuplicateIcons() {
    document.querySelectorAll(".modern-resource-icon").forEach(function (icon) {
      var previous = icon.previousElementSibling;
      if (previous && previous.matches("a") && previous.querySelector(".modern-resource-icon")) icon.remove();
    });
  }

  function enhanceLegacyImages() {
    document.querySelectorAll("#classifiers img:not(.turnstyleicon), #resultsTable img, #matchdocs img").forEach(function (image) {
      if (image.dataset.modernized) return;
      image.dataset.modernized = "true";
      image.classList.add("legacy-resource-icon");
      var link = image.closest("a");
      if (link && !link.querySelector(".modern-resource-icon")) {
        var icon = document.createElement("i");
        icon.className = "modern-resource-icon fa-regular fa-file-lines";
        link.prepend(icon);
      }
      if (link) link.classList.add("repo-listing-resource-link");
    });
  }

  function normalizeListingCardShells() {
    var resultsTable = document.querySelector("#resultsTable");
    if (resultsTable && resultsTable.querySelector(".result-collection")) {
      document.body.classList.add("repo-general-search");
      resultsTable.classList.add("repo-general-results");
    }
    document.querySelectorAll("#resultsTable tr.document").forEach(function (row) {
      var cells = Array.prototype.slice.call(row.children);
      var last = cells[cells.length - 1];
      if (last && !last.textContent.trim() && !last.querySelector("img, a, button, input, .modern-resource-icon")) {
        last.classList.add("repo-empty-tail-cell");
      }
    });
    document.querySelectorAll("#classifiers table[id^='div']").forEach(function (table) {
      if (table.classList.contains("childrenlist")) {
        table.classList.remove("repo-listing-card");
        return;
      }
      table.classList.add("repo-listing-card");
      table.querySelectorAll("tr").forEach(function (row) {
        var cells = Array.prototype.slice.call(row.children);
        var last = cells[cells.length - 1];
        if (last && cells.length > 2 && !last.textContent.trim() && !last.querySelector("img, a, button, input, .modern-resource-icon")) {
          last.classList.add("repo-empty-tail-cell");
          if (cells[cells.length - 2]) cells[cells.length - 2].classList.add("repo-card-content-cell");
        }
      });
      table.querySelectorAll("a").forEach(function (link) {
        if (link.querySelector(".modern-resource-icon")) link.classList.add("repo-listing-resource-link");
      });
      table.querySelectorAll("td").forEach(function (cell) {
        if (cell.dataset.listingCardWrapped === "true") return;
        var resource = cell.querySelector(":scope > a.repo-listing-resource-link");
        if (!resource) return;
        var content = document.createElement("div");
        content.className = "repo-listing-card-content";
        var node = resource.nextSibling;
        while (node) {
          var next = node.nextSibling;
          content.appendChild(node);
          node = next;
        }
        cell.appendChild(content);
        cell.dataset.listingCardWrapped = "true";
      });
    });
  }

  function markBrowseClassifierPage() {
    var match = window.location.pathname.match(/\/browse\/(CL[123])(?:\/|$)/i);
    if (!match) return;
    document.body.classList.add("repo-browse-classifier");
    document.body.classList.add("repo-browse-" + match[1].toLowerCase());
  }

  function authorLink(name) {
    var url = collectionSearchUrl(name);
    if (!url) return null;
    var link = document.createElement("a");
    link.className = "pill-green repo-author-link";
    link.href = url;
    link.innerHTML = '<i class="fa-solid fa-user-circle"></i> ' + name;
    return link;
  }

  function colabLink(name) {
    var url = collectionSearchUrl(name);
    if (!url) return null;
    var link = document.createElement("a");
    link.className = "pill-colab repo-colab-link";
    link.href = url;
    link.innerHTML = '<i class="fa-solid fa-user-edit"></i> ' + name;
    return link;
  }

  function subjectLink(value) {
    var url = collectionSearchUrl(value);
    if (!url) return null;
    var link = document.createElement("a");
    link.className = "repo-subject-chip";
    link.href = url;
    link.textContent = value;
    return link;
  }

  function createMetaLabel(icon, text) {
    var label = document.createElement("span");
    label.className = "repo-meta-label";
    label.innerHTML = '<i class="fa-solid ' + icon + '"></i> ' + text;
    return label;
  }

  function createAuthorLine(names) {
    var line = document.createElement("span");
    line.className = "repo-author-line";
    var label = document.createElement("span");
    label.className = "repo-author-label";
    label.innerHTML = '<i class="fa-solid fa-user-group"></i> Responsable/s';
    line.appendChild(label);
    var values = document.createElement("span");
    values.className = "repo-field-values";
    names.forEach(function (name, index) {
      var link = authorLink(name);
      if (link) {
          values.appendChild(link);
      } else {
          values.appendChild(document.createTextNode(name));
          if (index < names.length - 1) {
              values.appendChild(document.createTextNode("; "));
          }
      }
    });
    line.appendChild(values);
    return line;
  }

  function enhanceRecordAuthors(card) {
    card.querySelectorAll(".pill-green:not(a)").forEach(function (pill) {
      var name = pill.textContent.trim();
      var link = authorLink(name);
      if (link) pill.replaceWith(link);
    });
    card.querySelectorAll(".pill-colab:not(a)").forEach(function (pill) {
      var name = pill.textContent.trim();
      var link = colabLink(name);
      if (link) pill.replaceWith(link);
    });
  }

  function enhanceListingAuthors() {
    document.querySelectorAll("#classifiers td, #resultsTable td, #matchdocs td").forEach(function (cell) {
      if (cell.dataset.authorsModernized || !cell.textContent.match(/por\s*:/i)) return;
      var legacyAuthors = cell.querySelector("font");
      if (legacyAuthors) {
        var legacyNames = legacyAuthors.textContent.split(";").map(function (name) { return name.trim(); }).filter(Boolean);
        var legacyLine = createAuthorLine(legacyNames);
        var previous = legacyAuthors.previousElementSibling;
        if (previous && /^\s*por\s*:\s*$/i.test(previous.textContent)) previous.remove();
        legacyAuthors.replaceWith(legacyLine);
        cell.dataset.authorsModernized = "true";
        return;
      }
      var walker = document.createTreeWalker(cell, NodeFilter.SHOW_TEXT);
      var node;
      while ((node = walker.nextNode())) {
        var match = node.nodeValue.match(/^(\s*por\s*:\s*)(.+)$/i);
        if (!match) continue;
        var names = match[2].split(";").map(function (name) { return name.trim(); }).filter(Boolean);
        if (!names.length) continue;
        var line = createAuthorLine(names);
        node.parentNode.replaceChild(line, node);
        cell.dataset.authorsModernized = "true";
        break;
      }
    });
  }

  function enhanceSubjectChips() {
    document.querySelectorAll("#classifiers i:not([data-subject-modernized]), #resultsTable i:not([data-subject-modernized]), #matchdocs i:not([data-subject-modernized])").forEach(function (subject) {
      var text = subject.textContent.trim();
      if (!/^materias\s*:/i.test(text)) return;
      var values = text.replace(/^materias\s*:\s*/i, "").split(";").map(function (value) {
        return value.trim();
      }).filter(Boolean);
      if (!values.length) return;
      var line = document.createElement("span");
      line.className = "repo-subject-line";
      var label = document.createElement("span");
      label.className = "repo-subject-label";
      label.innerHTML = '<i class="fa-solid fa-tags"></i> Materias';
      line.appendChild(label);
      var subjectValues = document.createElement("span");
      subjectValues.className = "repo-field-values";
      values.forEach(function (value, index) {
        var chip = subjectLink(value);
        if (chip) {
             subjectValues.appendChild(chip);
        } else {
             subjectValues.appendChild(document.createTextNode(value));
             if (index < values.length - 1) {
                 subjectValues.appendChild(document.createTextNode("; "));
             }
        }
      });
      line.appendChild(subjectValues);
      subject.dataset.subjectModernized = "true";
      subject.replaceWith(line);
    });
  }

  function createEditorialLineLegacyUnused(value) {
    var values = value.split(";").map(function (item) { return item.trim(); }).filter(Boolean);
    if (!values.length) return null;
    var line = document.createElement("span");
    line.className = "repo-editorial-line";
    line.appendChild(createMetaLabel("fa-calendar-days", "Edición"));
    values.forEach(function (item, index) {
      if (index) {
        var separator = document.createElement("span");
        separator.className = "repo-meta-separator";
        separator.textContent = "|";
        line.appendChild(separator);
      }
      var text = document.createElement("span");
      if (/\b(?:18|19|20)\d{2}\b/.test(item)) text.className = "repo-editorial-year";
      text.textContent = item;
      line.appendChild(text);
    });
    return line;
  }

  function enhanceListingEditorialLegacyUnused() {
    document.querySelectorAll("#resultsTable td.result-main:not([data-editorial-modernized]), #classifiers table[id^='div'] td:nth-child(2):not([data-editorial-modernized])").forEach(function (cell) {
      var rule = cell.querySelector("hr");
      if (!rule) return;
      var node = rule.previousSibling;
      while (node && node.nodeType === Node.TEXT_NODE && !node.nodeValue.trim()) node = node.previousSibling;
      if (!node || node.nodeType !== Node.TEXT_NODE) return;
      var value = node.nodeValue.trim();
      if (!value) return;
      var line = createEditorialLine(value);
      if (!line) return;
      var previous = node.previousSibling;
      node.parentNode.replaceChild(line, node);
      if (previous && previous.nodeName === "BR") previous.remove();
      rule.remove();
      cell.dataset.editorialModernized = "true";
    });
  }

  function createEditorialLine(value) {
    var values = value.split(";").map(function (item) { return item.trim(); }).filter(Boolean);
    if (!values.length) return null;
    var line = document.createElement("span");
    line.className = "repo-editorial-line";
    line.appendChild(createMetaLabel("fa-calendar-days", "Edici\u00f3n"));
    var valueWrap = document.createElement("span");
    valueWrap.className = "repo-field-values";
    values.forEach(function (item, index) {
      if (index) {
        var separator = document.createElement("span");
        separator.className = "repo-meta-separator";
        separator.textContent = "|";
        valueWrap.appendChild(separator);
      }
      var text = document.createElement("span");
      if (/\b(?:18|19|20)\d{2}\b/.test(item)) text.className = "repo-editorial-year";
      text.textContent = item;
      valueWrap.appendChild(text);
    });
    line.appendChild(valueWrap);
    return line;
  }

  function enhanceListingEditorial() {
    document.querySelectorAll("#resultsTable td:not([data-editorial-modernized]), #classifiers table[id^='div'] td:not([data-editorial-modernized]), #matchdocs td:not([data-editorial-modernized])").forEach(function (cell) {
      var rule = cell.querySelector("hr");
      if (!rule) return;
      var node = rule.previousSibling;
      while (node && ((node.nodeType === Node.TEXT_NODE && !node.nodeValue.trim()) || (node.nodeType === Node.ELEMENT_NODE && node.nodeName === "BR"))) node = node.previousSibling;
      if (!node || node.nodeType !== Node.TEXT_NODE) return;
      var value = node.nodeValue.trim();
      if (!value || (value.indexOf(";") === -1 && !/\b(?:18|19|20)\d{2}\b/.test(value))) return;
      var line = createEditorialLine(value);
      if (!line) return;
      var previous = node.previousSibling;
      node.parentNode.replaceChild(line, node);
      if (previous && previous.nodeName === "BR") previous.remove();
      rule.remove();
      cell.dataset.editorialModernized = "true";
    });
  }

  function enhanceListingTitles() {
    document.querySelectorAll("#classifiers table[id^='div'] a[href*='/document/']:not(.repo-listing-title)").forEach(function (link) {
      if (link.querySelector(".modern-resource-icon")) return;
      link.classList.add("repo-listing-title");
    });
    document.querySelectorAll("#resultsTable .result-main a[href*='/document/']:not(.result-title)").forEach(function (link) {
      link.classList.add("result-title");
    });
  }

  function isLikelyListingEditorialText(value) {
    value = value.trim();
    if (!value || value.length > 160) return false;
    if (/^(por|materias)\s*:/i.test(value)) return false;
    return /(?:^|;)\s*(?:s\.?\s*f\.?|(?:18|19|20)\d{2})\s*$/i.test(value);
  }

  function createListingEditorialLine(value) {
    var parts = value.split(";").map(function (item) { return item.trim(); }).filter(Boolean);
    if (!parts.length) return null;
    var date = parts.pop();
    var publisher = parts.join("; ");
    var line = document.createElement("span");
    line.className = "repo-editorial-line repo-listing-editorial";
    line.appendChild(createMetaLabel("fa-calendar-days", "Edici\u00f3n"));
    var valueWrap = document.createElement("span");
    valueWrap.className = "repo-field-values";
    if (publisher && !/^s\.?\s*n\.?$/i.test(publisher)) {
      var publisherNode = document.createElement("span");
      publisherNode.className = "repo-editorial-publisher";
      publisherNode.textContent = publisher;
      valueWrap.appendChild(publisherNode);
      var separator = document.createElement("span");
      separator.className = "repo-meta-separator";
      separator.textContent = "|";
      valueWrap.appendChild(separator);
    }
    var dateNode = document.createElement("span");
    dateNode.className = "repo-editorial-year";
    dateNode.textContent = date;
    valueWrap.appendChild(dateNode);
    line.appendChild(valueWrap);
    return line;
  }

  function removeAdjacentBreaksAndRule(line) {
    var previous = line.previousSibling;
    if (previous && previous.nodeType === Node.ELEMENT_NODE && previous.nodeName === "BR") previous.remove();
    var next = line.nextSibling;
    if (next && next.nodeType === Node.ELEMENT_NODE && next.nodeName === "HR") {
      var afterRule = next.nextSibling;
      next.remove();
      if (afterRule && afterRule.nodeType === Node.ELEMENT_NODE && afterRule.nodeName === "BR") afterRule.remove();
    }
  }

  function normalizeListingEditorialLine(line) {
    if (!line || line.dataset.editorialMarkupNormalized === "true") return;
    var publisherNode = line.querySelector(".repo-editorial-publisher");
    var yearNode = line.querySelector(".repo-editorial-year");
    var publisher = publisherNode ? publisherNode.textContent.trim() : "";
    var year = yearNode ? yearNode.textContent.trim() : "";
    if (!year) return;
    var replacement = createListingEditorialLine(publisher ? publisher + ";" + year : year);
    if (!replacement) return;
    replacement.dataset.editorialMarkupNormalized = "true";
    var orphanIcon = line.nextSibling;
    line.parentNode.replaceChild(replacement, line);
    if (orphanIcon && orphanIcon.nodeType === Node.ELEMENT_NODE && orphanIcon.nodeName === "I" && orphanIcon.classList.contains("fa-calendar-days")) {
      orphanIcon.remove();
    }
  }

  function removeNextBreak(element) {
    if (!element) return;
    var anchor = element;
    if (element.classList && element.classList.contains("repo-listing-title") && element.parentElement && element.parentElement.nodeName === "B") {
      anchor = element.parentElement;
    }
    for (var i = 0; i < 2; i++) {
      var next = anchor.nextSibling;
      while (next && next.nodeType === Node.TEXT_NODE && !next.nodeValue.trim()) next = next.nextSibling;
      if (!next || next.nodeType !== Node.ELEMENT_NODE || next.nodeName !== "BR") break;
      next.remove();
    }
  }

  function compactListingCardBreaks() {
    document.querySelectorAll("#classifiers table[id^='div'] .repo-listing-title, #classifiers table[id^='div'] .repo-author-line, #classifiers table[id^='div'] .repo-subject-line, #classifiers table[id^='div'] .repo-listing-editorial").forEach(removeNextBreak);
    document.querySelectorAll("#resultsTable .result-title, #resultsTable .repo-author-line, #resultsTable .repo-subject-line, #resultsTable .repo-listing-editorial").forEach(removeNextBreak);
  }

  function enhanceClassifierCardEditorial() {
    document.querySelectorAll("#classifiers table[id^='div'] td:not([data-card-editorial-modernized])").forEach(function (cell) {
      if (cell.querySelector(".repo-listing-editorial")) {
        cell.dataset.cardEditorialModernized = "true";
        return;
      }
      if (!cell.querySelector(".repo-listing-title, .repo-author-line, .repo-subject-line")) return;
      var walker = document.createTreeWalker(cell, NodeFilter.SHOW_TEXT);
      var node;
      while ((node = walker.nextNode())) {
        var parent = node.parentElement;
        if (!parent || parent.closest("a, b, .repo-listing-title, .repo-author-line, .repo-subject-line, .repo-editorial-line")) continue;
        var value = node.nodeValue.trim();
        if (!isLikelyListingEditorialText(value)) continue;
        var line = createListingEditorialLine(value);
        if (!line) continue;
        node.parentNode.replaceChild(line, node);
        removeAdjacentBreaksAndRule(line);
        cell.dataset.cardEditorialModernized = "true";
        break;
      }
    });
    document.querySelectorAll("#classifiers table[id^='div'] .repo-listing-editorial").forEach(normalizeListingEditorialLine);
    document.querySelectorAll("#resultsTable .repo-listing-editorial").forEach(normalizeListingEditorialLine);
  }

  function affiliationSeparator() {
    var sep = document.createElement("span");
    sep.className = "repo-affiliation-separator";
    sep.setAttribute("aria-hidden", "true");
    sep.textContent = " | ";
    return sep;
  }

  function enhanceRecordMetadata(card) {
    card.querySelectorAll(".inti-row").forEach(function (row) {
      var label = row.querySelector(".inti-lbl");
      var value = row.querySelector(".inti-val");
      if (!label || !value || value.dataset.modernized) return;
      var text = label.textContent.toLowerCase();
      if (text.indexOf("autor") !== -1) row.classList.add("row-author");
      if (text.indexOf("colaborador") !== -1) row.classList.add("row-colab");
      if (text.indexOf("afili") !== -1) row.classList.add("row-affiliation");
      if (text.indexOf("resumen") !== -1) row.classList.add("row-summary");
      if (text.indexOf("fuente") !== -1) row.classList.add("row-source");
      if (text.indexOf("editor") !== -1) row.classList.add("row-editorial");
      if (text.indexOf("licencia") !== -1 || text.indexOf("derecho") !== -1) row.classList.add("row-license");
      if (text.indexOf("materia") !== -1) {
        row.classList.add("row-subject");
        var values = value.textContent.split(";").map(function (item) { return item.trim(); }).filter(Boolean);
        value.textContent = "";
        var line = document.createElement("span");
        line.className = "repo-subject-line";
        values.forEach(function (item) {
          var chip = subjectLink(item);
          if (chip) line.appendChild(chip);
        });
        value.appendChild(line);
        value.dataset.modernized = "true";
      } else if (text.indexOf("editor") !== -1) {
        var editorial = createEditorialLine(value.textContent);
        if (!editorial) return;
        var innerLabel = editorial.querySelector(".repo-meta-label");
        if (innerLabel) innerLabel.remove();
        editorial.classList.add("repo-record-editorial");
        value.textContent = "";
        value.appendChild(editorial);
        value.dataset.modernized = "true";
      } else if (text.indexOf("afili") !== -1) {
        var parts = value.innerHTML.split(/<br\s*\/?>/i).map(function (item) {
          var wrapper = document.createElement("span");
          wrapper.innerHTML = item;
          return wrapper.textContent.trim();
        }).filter(Boolean);
        if (!parts.length) return;
        var list = document.createElement("span");
        list.className = "repo-affiliation-list";
        parts.forEach(function (part) {
          var item = document.createElement("span");
          item.className = "repo-affiliation-item";
          var split = part.match(/^(.+?)(\s+(?:Instituto|Universidad|Centro|Consejo|Comisi[oó]n|Laboratorio|Fundaci[oó]n|Facultad|Departamento|Argentina)\b.*)$/i);
          if (split) {
            var author = document.createElement("strong");
            author.className = "repo-affiliation-author";
            author.textContent = split[1];
            item.appendChild(author);
            var details = split[2].trim();
            var institution = details;
            var location = "";
            var locationSplit = details.match(/^(.*?)(?:\s*;\s*|\s+\|\s+|\s+-\s+)([^;|]+)$/);
            if (locationSplit) {
              institution = locationSplit[1].trim();
              location = locationSplit[2].trim();
            } else {
              var countrySplit = details.match(/^(.*?)(\s+(?:Argentina|Brasil|Brazil|Chile|Uruguay|Paraguay|Bolivia|Peru|M[eÃ©]xico|Mexico|Espa[nÃ±]a|Spain|Estados Unidos|United States))$/i);
              if (countrySplit) {
                institution = countrySplit[1].trim();
                location = countrySplit[2].trim();
              }
            }
            if (institution) {
              var inst = document.createElement("span");
              inst.className = "repo-affiliation-institution";
              inst.innerHTML = '<i class="fa-solid fa-building-columns" aria-hidden="true"></i><span></span>';
              inst.querySelector("span").textContent = institution;
              item.appendChild(affiliationSeparator());
              item.appendChild(inst);
            }
            if (location) {
              var place = document.createElement("span");
              place.className = "repo-affiliation-place";
              place.innerHTML = '<i class="fa-solid fa-globe" aria-hidden="true"></i><span></span>';
              place.querySelector("span").textContent = location;
              var placeGroup = document.createElement("span");
              placeGroup.className = "repo-affiliation-place-group";
              placeGroup.appendChild(affiliationSeparator());
              placeGroup.appendChild(place);
              item.appendChild(placeGroup);
            }
          } else {
            item.textContent = part;
          }
          list.appendChild(item);
        });
        value.textContent = "";
        value.appendChild(list);
        value.dataset.modernized = "true";
      }
    });
  }

  function extractMetadataForCart(card) {
    var title = card.querySelector("h1") ? card.querySelector("h1").textContent.trim() : "Documento sin título";
    var authors = Array.from(card.querySelectorAll(".row-author .repo-affiliation-author, .row-author .inti-val")).map(function(el) { return el.textContent.replace(/\|$/, '').trim(); }).filter(Boolean);
    var editor = "";
    var edRow = card.querySelector(".row-editorial .inti-val");
    if (edRow) editor = edRow.textContent.trim();
    
    // Extraer año de la edición (ej. "INTI | 2022") o del título
    var anio = "";
    var anioMatch = editor.match(/\b(19\d\d|20\d\d)\b/);
    if (anioMatch) {
      anio = anioMatch[1];
      editor = editor.replace(/\s*\|\s*\b(19\d\d|20\d\d)\b/, "").trim();
    }
    
    return {
      title: title,
      autor: authors.length > 0 ? authors[0] : "",
      autoresRaw: authors.join("|||"),
      editor: editor,
      anio: anio,
      uri: window.location.href,
      savedAt: new Date().toISOString()
    };
  }

  function compactLicenseName(text) {
    var normalized = (text || "").replace(/\s+/g, " ").trim();
    if (!normalized) return "";
    var ccUrlMatch = normalized.match(/creativecommons\.org\/licenses\/([^/\s]+)/i);
    if (ccUrlMatch) return "CC " + ccUrlMatch[1].replace(/\s+/g, "-").toUpperCase();
    var ccMatch = normalized.match(/\bCC\s+((?:BY|NC|ND|SA|0)(?:[-\s]+(?:BY|NC|ND|SA|0))*)\b/i);
    if (ccMatch) return "CC " + ccMatch[1].replace(/\s+/g, "-").toUpperCase();
    if (/creative commons/i.test(normalized)) return "Creative Commons";
    return "";
  }

  function licenseTooltip(label) {
    var normalized = (label || "").replace(/\s+/g, " ").trim().toUpperCase();
    if (!normalized) return "Ver licencia";
    var parts = normalized.replace(/^CC\s+/, "").split("-").filter(Boolean);
    var names = {
      "BY": "Atribucion",
      "NC": "NoComercial",
      "ND": "SinDerivadas",
      "SA": "CompartirIgual",
      "0": "Dominio publico"
    };
    var expanded = parts.map(function (part) { return names[part] || part; }).join(" - ");
    if (!expanded) return "Creative Commons";
    return "Creative Commons " + expanded;
  }

  function licenseUrlFromText(text) {
    var match = (text || "").match(/https?:\/\/[^\s<>"']+/i);
    return match ? match[0] : "";
  }

  function isTechnicalRightsValue(value) {
    var normalized = (value || "").replace(/\s+/g, " ").replace(/[;\s]+$/g, "").trim();
    if (!normalized) return true;
    return /^info:[a-z-]+-repo\/semantics\//i.test(normalized) || /^openAccess$/i.test(normalized);
  }

  function humanRightsSegments(text) {
    return (text || "")
      .split(";")
      .map(function (part) { return part.trim(); })
      .filter(function (part) {
        return part && !isTechnicalRightsValue(part) && !/creativecommons\.org\/licenses\//i.test(part);
      });
  }

  function enhanceRecordLicense(card) {
    var text = card.querySelector(".repo-license-text");
    if (!text || text.dataset.modernized) return;
    var rawText = text.textContent.trim();
    var existingLink = text.querySelector("a[href]");
    var rawUrl = existingLink ? existingLink.href : licenseUrlFromText(rawText);
    var badgeText = compactLicenseName(rawText);
    if (!badgeText && rawUrl) badgeText = compactLicenseName(rawUrl);
    var segments = humanRightsSegments(rawText);

    text.textContent = "";

    if (badgeText) {
      var badge = document.createElement(rawUrl ? "a" : "span");
      badge.className = "repo-license-badge";
      if (rawUrl) {
        badge.href = rawUrl;
        badge.target = "_blank";
        badge.rel = "noopener";
        badge.title = licenseTooltip(badgeText);
        badge.setAttribute("aria-label", licenseTooltip(badgeText) + ". Abrir licencia en una nueva pestana");
      }
      badge.innerHTML = '<i class="fa-brands fa-creative-commons" aria-hidden="true"></i><span></span>';
      badge.querySelector("span").textContent = badgeText;
      if (rawUrl) {
        var external = document.createElement("i");
        external.className = "fa-solid fa-arrow-up-right-from-square";
        external.setAttribute("aria-hidden", "true");
        badge.appendChild(external);
      }
      text.appendChild(badge);
    }

    segments.forEach(function (segment) {
      var note = document.createElement("span");
      note.className = "repo-license-note";
      note.textContent = segment;
      text.appendChild(note);
    });

    if (rawUrl && !badgeText) {
      var generatedLink = document.createElement("a");
      generatedLink.href = rawUrl;
      generatedLink.target = "_blank";
      generatedLink.rel = "noopener";
      generatedLink.appendChild(document.createTextNode("Ver licencia"));
      text.appendChild(generatedLink);
    }

    text.querySelectorAll("a").forEach(function (link) {
      if (/^https?:\/\//i.test(link.textContent.trim())) {
        link.textContent = "Ver licencia";
      }
      if (!link.querySelector("i")) {
        var icon = document.createElement("i");
        icon.className = "fa-solid fa-arrow-up-right-from-square";
        icon.setAttribute("aria-hidden", "true");
        link.appendChild(icon);
      }
    });
    text.dataset.modernized = "true";
  }

  function createRecordActions(card) {
    var head = card.querySelector(".head-top");
    if (!head || head.querySelector(".record-action--share")) return;
    var actions = head.querySelector(".record-actions");
    if (!actions) {
      actions = document.createElement("span");
      actions.className = "record-actions";
      head.appendChild(actions);
    }
    actions.insertAdjacentHTML("afterbegin",
      '<button type="button" class="record-action record-action--share"><i class="fa-solid fa-share-nodes"></i><span>Compartir</span></button>' +
      '<button type="button" class="record-action record-action--save"><i class="fa-regular fa-bookmark"></i><span>Guardar</span></button>');

    var save = actions.querySelector(".record-action--save");
    var storageKey = "inti-repository-saved-records";
    
    function refresh() {
      var records = JSON.parse(window.localStorage.getItem(storageKey) || "{}");
      var active = Boolean(records[window.location.href]);
      save.classList.toggle("is-active", active);
      save.querySelector("i").className = active ? "fa-solid fa-bookmark" : "fa-regular fa-bookmark";
      save.querySelector("span").textContent = active ? "Guardado" : "Guardar";
    }
    
    actions.querySelector(".record-action--share").addEventListener("click", copyCurrentUrl);
    save.addEventListener("click", function () {
      var records = JSON.parse(window.localStorage.getItem(storageKey) || "{}");
      if (records[window.location.href]) {
        delete records[window.location.href];
        showToast("Registro quitado de guardados");
      } else {
        records[window.location.href] = extractMetadataForCart(card);
        showToast("Registro guardado");
        var dock = document.getElementById("cart-dock");
        if (dock && !dock.classList.contains("open")) {
          dock.classList.add("open");
        }
      }
      window.localStorage.setItem(storageKey, JSON.stringify(records));
      refresh();
      if (typeof updateCartUI === "function") updateCartUI();
    });
    refresh();
  }

  function repairFullText(card) {
    card.querySelectorAll(".row-vermas > a:not([data-modernized])").forEach(function (link) {
      link.dataset.modernized = "true";
      var source = link.getAttribute("href") || link.getAttribute("onclick") || "";
      var match = source.match(/mostrar\(['"]([^'"]+)['"]\)/);
      if (!match) return;
      var original = document.getElementById(match[1]);
      if (!original) return;
      var panel = document.createElement("div");
      panel.className = "record-fulltext";
      panel.innerHTML = original.innerHTML;
      link.insertAdjacentElement("afterend", panel);
      link.setAttribute("aria-expanded", "false");
      link.addEventListener("click", function (event) {
        event.preventDefault();
        var open = panel.classList.toggle("is-open");
        link.setAttribute("aria-expanded", open ? "true" : "false");
        var label = link.querySelector("span");
        if (label) label.textContent = open ? "Ocultar texto" : "Ver texto completo";
      });
      var label = link.querySelector("span");
      if (label) label.textContent = "Ver texto completo";
    });
  }

  function enhanceRecord() {
    document.querySelectorAll(".inti-card").forEach(function (card) {
      card.querySelectorAll(".btn-pdf").forEach(function (link) {
        link.target = "_blank";
        link.rel = "noopener";
      });
      enhanceRecordAuthors(card);
      enhanceRecordMetadata(card);
      enhanceRecordLicense(card);
      createRecordActions(card);
      repairFullText(card);
    });
  }

  function enhanceQuery() {
    var form = document.querySelector('form[name="QueryForm"]');
    if (!form || form.previousElementSibling && form.previousElementSibling.classList.contains("query-intro")) return;
    var intro = document.createElement("section");
    intro.className = "query-intro";
    var searchType = "Búsqueda Simple";
    var formAction = form.getAttribute("action") || "";
    if (formAction.indexOf("FieldQuery") !== -1 || formAction.indexOf("Advanced") !== -1) {
      searchType = "Búsqueda Avanzada";
    } else if (formAction.indexOf("TextQuery") !== -1) {
      searchType = "Búsqueda por Texto";
    }
    intro.innerHTML = '<span class="section-kicker">' + searchType + '</span><h1>Buscá dentro de la colección</h1><p>Combiná términos y filtros para precisar el resultado. Para empezar, alcanza con ingresar una palabra significativa.</p>';
    form.parentNode.insertBefore(intro, form);
    form.classList.add("query-modern-form");
    var root = form.querySelector(":scope > div");
    if (!root) return;
    root.querySelectorAll(".paramLabel").forEach(function (label) {
      var value = label.nextElementSibling;
      if (!value || !value.classList.contains("paramValue")) return;
      var row = document.createElement("div");
      row.className = "query-param-row";

      var txt = label.textContent.trim();
      if (txt === "Cadena de búsqueda") {
        label.textContent = "T\u00E9rminos a buscar";
        row.classList.add("query-param-row--main");
      }
      else if (txt === "Hits por página") label.textContent = "Resultados por página";
      else if (txt === "Indice en el cual buscar") label.textContent = "Buscar dentro de";
      else if (txt === "Coincidir") label.textContent = "Modo de coincidencia";
      else if (txt === "Ordenar resultados de búsqueda por") label.textContent = "Ordenar por";
      else if (txt === "Orden inverso") label.textContent = "Invertir orden";

      label.parentNode.insertBefore(row, label);
      row.appendChild(label);
      row.appendChild(value);
      if (!label.textContent.trim() && !value.querySelector("input:not([type='hidden']), select, textarea")) row.classList.add("query-param-row--hidden");
    });
    root.querySelectorAll("table").forEach(function (table) {
      table.classList.add("query-fields-table");
      form.classList.add("query-modern-form--advanced");
    });
    root.querySelectorAll("select[name$='reverseSort'] option").forEach(function (option) {
      if (option.value === "1") option.textContent = "activado";
      if (option.value === "0") option.textContent = "desactivado";
    });
    var submit = root.querySelector("input[type='submit']");
    if (submit) {
      var submitRow = document.createElement("div");
      submitRow.className = "query-submit-row";
      submit.parentNode.insertBefore(submitRow, submit);
      submitRow.appendChild(submit);
    }
  }

  function observeDynamicContent() {
    if (document.documentElement.dataset.repoDynamicObserverReady) return;
    var root = document.querySelector("#gs_content");
    if (!root || !window.MutationObserver) return;
    document.documentElement.dataset.repoDynamicObserverReady = "true";
    var timer;
    new MutationObserver(function () {
      window.clearTimeout(timer);
      timer = window.setTimeout(enhance, 60);
    }).observe(root, { childList: true, subtree: true });
  }

  /* ==========================================================================
     LÓGICA DEL PANEL DE GUARDADOS Y CITAS
     ========================================================================== */
  var storageKey = "inti-repository-saved-records";

  window.toggleCart = function() {
    var dock = document.getElementById("cart-dock");
    if (!dock) return;
    dock.classList.toggle("open");
  };

  window.removeSaved = function(uri, event) {
    var itemEl = null;
    if (event) {
      event.preventDefault();
      event.stopPropagation();
      itemEl = event.target.closest('.cart-item');
    }
    
    var performRemoval = function() {
      var records = JSON.parse(window.localStorage.getItem(storageKey) || "{}");
      if (records[uri]) {
        delete records[uri];
        window.localStorage.setItem(storageKey, JSON.stringify(records));
        updateCartUI();
        showToast("Registro quitado de guardados");
        
        var save = document.querySelector(".record-action--save");
        if (save && window.location.href.indexOf(uri) !== -1) {
          save.classList.remove("is-active");
          save.querySelector("i").className = "fa-regular fa-bookmark";
          save.querySelector("span").textContent = "Guardar";
        }
      }
    };

    if (itemEl) {
      var h = itemEl.offsetHeight;
      itemEl.style.overflow = "hidden";
      // Animate exact height to 0 smoothly overriding any grid/gap limits
      var anim = itemEl.animate([
        { height: h + 'px', opacity: 1, margin: window.getComputedStyle(itemEl).margin, padding: window.getComputedStyle(itemEl).padding, border: window.getComputedStyle(itemEl).border },
        { height: '0px', opacity: 0, margin: '0px', padding: '0px', borderWidth: '0px' }
      ], { duration: 300, easing: 'ease' });
      anim.onfinish = performRemoval;
    } else {
      performRemoval();
    }
  };

  function cerrarConPunto(texto) {
    var limpio = String(texto || "").trim();
    if (!limpio) return "";
    return /[.!?]$/.test(limpio) ? limpio : limpio + ".";
  }

  function citaAPAItem(d) {
    return cerrarConPunto(d.autor) + " (" + (d.anio || "s.f.") + "). " + cerrarConPunto(d.title) + " " + cerrarConPunto(d.editor || "Biblioteca Central INTI");
  }

  function citaISOItem(d) {
    return cerrarConPunto((d.autor || "").toUpperCase()) + " " + cerrarConPunto(d.title) + " " + (d.editor || "INTI") + ", " + (d.anio || "s.f.") + ".";
  }

  window.clearCart = function() {
    if (!confirm("¿Estás seguro de que querés borrar todos los registros guardados?")) return;
    window.localStorage.removeItem(storageKey);
    updateCartUI();
    showToast("Se han borrado todos los registros");
    // Si estamos en un registro, apagar su botón
    var save = document.querySelector(".record-action--save");
    if (save) {
      save.classList.remove("is-active");
      save.querySelector("i").className = "fa-regular fa-bookmark";
      save.querySelector("span").textContent = "Guardar";
    }
  };

  window.exportCart = function(format) {
    var records = JSON.parse(window.localStorage.getItem(storageKey) || "{}");
    var items = Object.keys(records).map(function(k) { return records[k]; });
    if (!items.length) {
      alert("No hay registros guardados.");
      return;
    }
    var rows = items.map(function(d, i) {
      return {
        id: "INTI" + (i + 1),
        autor: d.autor || "",
        titulo: d.title || "",
        anio: d.anio || "",
        tipo: d.tipo || "Documento",
        uri: d.uri,
        editor: d.editor || ""
      };
    });
    
    var text = "";
    var filename = "repositorio-inti-" + format + ".txt";
    var mime = "text/plain;charset=utf-8";

    if (format === "ris") {
      text = rows.map(function(r) { return "TY  - GEN\nAU  - " + r.autor + "\nTI  - " + r.titulo + "\nPY  - " + r.anio + "\nUR  - " + r.uri + "\nER  -"; }).join("\n\n");
      filename = "repositorio-inti.ris";
    } else if (format === "bibtex") {
      text = rows.map(function(r) { return "@misc{" + r.id + ",\n  author = {" + r.autor + "},\n  title = {" + r.titulo + "},\n  year = {" + r.anio + "},\n  url = {" + r.uri + "}\n}"; }).join("\n\n");
      filename = "repositorio-inti.bib";
    } else if (format === "csv") {
      var csvEsc = function(v) { return '"' + String(v || "").replace(/"/g, '""') + '"'; };
      text = ["autor,titulo,anio,editor,uri"].concat(rows.map(function(r) {
        return [r.autor, r.titulo, r.anio, r.editor, r.uri].map(csvEsc).join(",");
      })).join("\n");
      filename = "repositorio-inti.csv";
      mime = "text/csv;charset=utf-8";
    } else if (format === "apa") {
      text = items.map(citaAPAItem).join("\n\n");
      filename = "repositorio-inti-apa.txt";
    } else if (format === "iso") {
      text = items.map(citaISOItem).join("\n\n");
      filename = "repositorio-inti-iso.txt";
    }
    
    var blob = new Blob([text], { type: mime });
    var url = URL.createObjectURL(blob);
    var a = document.createElement("a");
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    a.remove();
    URL.revokeObjectURL(url);
  };

  window.updateCartUI = function() {
    var list = document.getElementById("cart-list");
    var count = document.getElementById("cart-count");
    if (!list || !count) return;
    var records = JSON.parse(window.localStorage.getItem(storageKey) || "{}");
    var keys = Object.keys(records);
    count.textContent = keys.length;
    
    // Guardamos los URIs que ya estaban en el DOM para no animarlos de nuevo
    var existingUris = {};
    list.querySelectorAll('.cart-item').forEach(function(el) {
      if (el.getAttribute('href')) existingUris[el.getAttribute('href')] = true;
    });

    list.innerHTML = "";
    keys.forEach(function(uri) {
      var rec = records[uri];
      var div = document.createElement("a");
      div.className = "cart-item" + (existingUris[uri] ? "" : " adding");
      div.href = uri;
      div.innerHTML = '<div><strong>' + (rec.title || "Documento") + '</strong><span>' + (rec.autor || "Sin autor") + (rec.anio ? " (" + rec.anio + ")" : "") + '</span></div>' +
                      '<button type="button" class="mini-btn danger cart-remove" onclick="removeSaved(\'' + uri + '\', event)" title="Quitar"><i class="fa-solid fa-times"></i></button>';
      list.appendChild(div);
      
      if (!existingUris[uri]) {
        requestAnimationFrame(function() {
          requestAnimationFrame(function() {
            div.classList.remove("adding");
          });
        });
      }
    });
  };

  function initCart() {
    if (document.getElementById("cart-dock")) return;
    var dockHTML = 
      '<div class="cart-dock" id="cart-dock">' +
      '  <div class="cart-head" onclick="toggleCart()">' +
      '    <span><i class="fa-solid fa-bookmark"></i> Mis guardados (<span id="cart-count">0</span>)</span>' +
      '    <i class="fa-solid fa-chevron-up"></i>' +
      '  </div>' +
      '  <div class="cart-body">' +
      '    <div class="cart-list" id="cart-list"></div>' +
      '    <div class="cart-actions">' +
      '      <button class="mini-btn primary" onclick="exportCart(\'ris\')">RIS</button>' +
      '      <button class="mini-btn primary" onclick="exportCart(\'bibtex\')">BibTeX</button>' +
      '      <button class="mini-btn primary" onclick="exportCart(\'csv\')">CSV</button>' +
      '      <button class="mini-btn" onclick="exportCart(\'apa\')">APA</button>' +
      '      <button class="mini-btn" onclick="exportCart(\'iso\')">ISO</button>' +
      '      <button class="mini-btn danger" onclick="clearCart()">Vaciar</button>' +
      '    </div>' +
      '  </div>' +
      '</div>';
    document.body.insertAdjacentHTML("beforeend", dockHTML);
    updateCartUI();
  }

  function enhanceResultsInfo() {
    var matchdocs = document.getElementById("matchdocs");
    var terminfos = document.querySelectorAll(".termInfo");
    if (!matchdocs || matchdocs.dataset.enhanced) return;
    
    matchdocs.innerHTML = '<i class="fa-solid fa-search matchdocs-icon"></i> ' + matchdocs.innerHTML.replace("consulta.", "consulta");
    
    var wrapper = document.createElement("div");
    wrapper.className = "query-results-wrapper";
    matchdocs.parentNode.insertBefore(wrapper, matchdocs);
    wrapper.appendChild(matchdocs);
    
    if (terminfos.length > 0) {
        terminfos.forEach(function(ti) {
           wrapper.appendChild(ti);
        });
    }
    
    var termListP = document.querySelector(".termList");
    if (termListP && termListP.textContent.trim() === "") {
        termListP.style.display = "none";
    }
    
    matchdocs.dataset.enhanced = "true";
  }

  function enhance() {
    enhanceResultsInfo();
    markBrowseClassifierPage();
    initCart();
    enhanceNavigation();
    enhanceToggleIcons();
    enhanceLegacyImages();
    normalizeListingCardShells();
    removeDuplicateIcons();
    enhanceListingAuthors();
    enhanceSubjectChips();
    enhanceListingEditorial();
    enhanceListingTitles();
    enhanceClassifierCardEditorial();
    compactListingCardBreaks();
    enhanceRecord();
    enhanceQuery();
    sortCL2YearsDescending();
    observeDynamicContent();
  }

  function sortCL2YearsDescending() {
    // Detecta el contenedor de la lista de años (CL2 = clasificador por Fecha)
    // Greenstone renderiza cada año como un <td> dentro de la tabla .childrenlist
    // Solo actúa si la URL contiene /browse/CL2 (clasificador de fecha)
    if (!/\/browse\/CL2/i.test(window.location.href)) return;
    var lists = document.querySelectorAll(".childrenlist table");
    lists.forEach(function (table) {
      var rows = Array.prototype.slice.call(table.querySelectorAll("tr"));
      if (rows.length < 2) return;
      // Ordena descendente: extrae el texto del primer <a> o td con año
      rows.sort(function (a, b) {
        var ta = (a.textContent || "").trim();
        var tb = (b.textContent || "").trim();
        // Extraer número de año al inicio del texto
        var ya = parseInt(ta.match(/\b(\d{4})\b/), 10) || 0;
        var yb = parseInt(tb.match(/\b(\d{4})\b/), 10) || 0;
        return yb - ya; // descendente
      });
      var tbody = table.querySelector("tbody") || table;
      rows.forEach(function (row) { tbody.appendChild(row); });
    });
  }

  window.repoModernEnhance = enhance;

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", enhance);
  else enhance();
  window.setTimeout(enhance, 200);
  window.setTimeout(enhance, 800);
})();
