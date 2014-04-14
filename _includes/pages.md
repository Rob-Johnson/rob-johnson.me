{% for page in site.pages| sort:"path"%} [{% if page.url-title %} <em>{{ page.url-title }}</em> {% else %} <em>{{ page.title }}</em> {% endif %}]({{ page.url }}){% endfor %}
