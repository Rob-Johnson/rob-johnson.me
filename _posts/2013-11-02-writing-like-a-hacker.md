---
layout: post
title: "Writing Like a Hacker"
description: ""
category: 
tags: []
---

I've been writing the Interim Report for my dissertation for a week or so now, and I wan't to share how I made the whole experience more 'hacker friendly'.

I've become accustomed to any work I do happening in the terminal; I stopped using IDEs in favour of Vim permanently a while ago, and I write lecture notes at University in [Markdown](http://daringfireball.net/projects/markdown/) (go check it out - it's awesome) using, you guessed it, Vim. Up until now I've always written any reports I've been assigned using a word processor like Apple's Pages. The problem, however, in using Vim for everything is that using anything else has become counter productive.

Given that my disseration is worth 24% of my degree, I thought it worth spending a bit of time making in look as presentable as possible. Of course, I chose Donald Knuth's [LaTeX](http://www.latex-project.org/), and went about learning the basics of using it.
One thing that did strike me is the seemingly accepted, crazily repetivive process of compiling it. Here's the sequence a user is subjected to in order to compile the file along with the bibliography:
  
    pdflatex interim_report.tex \
    && bibtex interim_report.aux \
    && pdflatex interim_report.tex \
    && pdflatex interim_report.tex

Yeah, thats four commands to get what you need. Dumb isn't it.

Anyway, this pissed me off a little, and as much as I could have looked to a LaTeX editor that did all this for me, I would've had the same problems I would've found with any other text editor. Typing 

    ESC ciw 

would certainly not have done what I wanted.

Of course, the solution was to automate this crap so I could write in Vim, and not have to run all these commands every time I make a change to the document. An alias wouldn't have been enough, given that I'd still have to type the alias every time I wanted to see the change - I wanted something that: 

  * Detects whenever I save a file affecting the document.
  * Compiles whatever is necessary.

Luckily, this is simple with the right tools.

[Guard](http://guardgem.org/) is a command line tool to handle events on file system modifications. I use it in most projects (it's written in Ruby, but a language agnostic tool - I use it in Python projects as well), to run tests on changes, recompile assets etc. so it was a perfect choice for what I need it. It has a easy to use plugin interface that allows various actions to be run those changes.

With Guard, I used [Guard Shell](https://github.com/guard/guard-shell), a simple but effective plugin to run shell commands on changes. This allows me to run the latex compilation whenever I save a file.

So, in your Gemfile:

    source 'https://rubygems.org'

    gem 'guard'
    gem 'guard-shell'
    gem 'growl'

Then add this into a Guardfile

    notification :growl

    guard :shell do
      watch /^.*?\.tex|bib|sty/ do |m|
        puts 'compiling latex'
        out = `pdflatex -halt-on-error interim_report.tex \
              && bibtex interim_report.aux \
              && pdflatex -halt-on-error interim_report.tex \
              && pdflatex -halt-on-error interim_report.tex`
        if $?.to_i == 0
          puts 'successfully compiled'
          count = `texcount -inc -nc -1 interim_report.tex`.split('+').first
          msg = "Built interim_report.pdf (#{count} words). \n"
          Dir.glob("*/*.tex").map{ |f| puts f; msg << "#{f}: " << `texcount -inc -nc -1 '#{f}'`.split('+').first << " words \n"}
        else
          puts out
          msg = "Failed to build"
        end
        n msg, 'LaTeX'
        "-> #{msg}"
      end
    end

To break this down the Guardfile will:

   * Watch for changes on .tex, .bib and .sty files
   * Compile the appropriate tex file on change
   * Check the exit signal of process and either:
      * On sucess, get the wordcount of each tex file (I have each chapter in a separate file), and the entire document.
      * On failure, print the std out of the compilation process to the std out of Guard
  * Notify with the appropriate success or failure message, along with the count stats (you can configure how you're notified, I use growl).

Once this is setup, assuming you have [Bundler](http://bundler.io/) installed just run:


      bundle exec guard

That's it, you're done!

Contact me if you've got any questions or feedback!
