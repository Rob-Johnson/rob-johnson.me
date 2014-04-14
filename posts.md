---
layout: page
title: Posts
---
<h2>Posts</h2>
{% render pages.md %}

{% for post in site.posts %}
  * [{{ post.title }}]({{ post.url }})
{% endfor %}
