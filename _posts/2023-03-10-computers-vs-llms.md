---
layout: distill
title: Large Language Models Are Zero-Shot Problem Solvers <br> &mdash; Just Like Modern Computers
description: Are large language models going to redefine the next generation of computers?
giscus_comments: true
date: 2023-03-10

authors:
  - name: Tim Z. Xiao
    url: "http://timx.me"
    affiliations:
      name: University of Tübingen, IMPRS-IS
  - name: Weiyang Liu
    url: "https://wyliu.com"
    affiliations:
      name: University of Cambridge, MPI-IS
  - name: Robert Bamler
    url: "https://robamler.github.io"
    affiliations:
      name: University of Tübingen

bibliography: 2023-03-10-computers-vs-llms.bib

# Optionally, you can add a table of contents to your post.
# NOTES:
#   - make sure that TOC names match the actual section names
#     for hyperlinks within the post to work correctly.
#   - we may want to automate TOC generation in the future using
#     jekyll-toc plugin (https://github.com/toshimaru/jekyll-toc).
toc:
  - name: Abstract
  - name: Introduction
  - name: A Tale of Two Zero-Shot Problem Solvers
    subsections:
      - name: Connecting the Dots
      - name: Fundamental Difference
  - name: Lessons to Learn

# Below is an example of injecting additional post-specific styles.
# If you use this post as a template, delete this _styles block.
_styles: >
  .finding {
    border-left: 8px solid hsl(218, 70%, 80%);
    padding: 12px;
    padding-left: 16px;
    margin-bottom: 16px;
    border-radius: 4px;
    background: hsl(218, 80%, 95%);
    color: #1C1C1D;
    font-style: italic;
    font-family: 'Times New Roman', Times, serif;
  }

  .finding-start {
    font-style: normal;
    font-weight: bold;
    display: block;
    padding-bottom: 4px;
    color: #1C1C1D;
  }

---

<a name="abstract"></a>
Language models (LMs) are trained specifically for one out of many natural language processing (NLP) tasks. 
By simply scaling them up to large LMs (LLMs), they emerge the ability to solve many other NLP tasks that they have not been trained for.
This emergence of zero-shot problem solving ability of LLMs surprised the community. 
In this blog, we draw an overlooked connection between LLMs and modern computers that also emerge zero-shot problem solving abilities.
We discuss their similarities in capability, architecture, and history, and then use these similarities to motivate a different perspective on understanding LLMs and the prompting paradigm.
We hope this connection can help us gain a deeper understanding of LLMs, and can spark discussions between the core computer science community and the foundation model community.


## Introduction

Thanks to increasingly powerful computation infrastructures, we have witnessed many significant breakthroughs delivered by simply scaling up deep learning models in recent years.
This is partially due to the empirical findings that for many tasks in natural language processing (NLP) and computer vision, the scale of a model and its test performance are so positively correlated that knowing either, one can even predict the other.
Such relationship is described by the _scaling laws_<d-cite key="hestness2017deep, kaplan2020scaling, ganguli2022predictability"></d-cite>.
In other words, it is not surprising that a larger language model can achieve a better performance in the task of language modeling.

However, recent development in large language models (LLMs) such as GPT-3<d-cite key="brown2020language"></d-cite> and ChatGPT<d-cite key="chatgpt2022"></d-cite> has attracted an unusual amount of interest from both the machine learning community as well as the general public.
Apart from the imaginative conversations people had with LLMs, a more fundamental reason is that LLMs are not only showing improvements in language modeling but also showing the abilities to solve a wide range of NLP tasks including question answering, translation, summarization and even algorithmic tasks<d-cite key="radford2019language, brown2020language, chowdhery2022palm, zhou2022teaching"></d-cite>.
This means by training on a single task, the model gains the ability to solve tasks it has never been trained for.
Such an emergence of _zero-shot_<d-footnote>We use the term <em>zero-shot</em> to highlight that the model is not trained for the tested tasks (similar to its usage in the GPT-2 paper<d-cite key="radford2019language"></d-cite>).
This is sometimes also called <em>universal</em> or <em>general</em> problem solving.
In many other LLM papers<d-cite key="kojima2022large"></d-cite>, <em>zero-shot</em> means no demonstration is provided during inference time in the prompt. 
Here we treat both zero-shot and few-shot prompting as examples of zero-shot problem solving.</d-footnote>
problem solving abilities in LLMs is surprising and was not predicted from the smaller scale models<d-cite key="wei2022emergent"></d-cite>.
It is still an open question how LLMs emerge with their abilities.

The phenomenon of a system showing spontaneous abilities that cannot be predicted when scaled up is known as _emergence_.
Emergence is not a unique phenomenon that happens only in LLMs.
It has been observed and discussed in many other subjects including physics and biology at least half a century ago.
In the field of machine learning, emergence was also discussed and has inspired pioneer works such as the Hopfield network<d-cite key="hopfield1982neural"></d-cite>.
The phenomenon is well explicated in an article by Philip W. Anderson<d-cite key="anderson1972more"></d-cite> with a concise title ***''More Is Different''***.

Another example that has emergent ability are the computers we use in our daily life.
The elementary components in modern computers are logic gates, which are designed to do simple Boolean operations only, e.g., _AND_, _OR_. 
But when we wire a large amount of them together, they emerge with the abilities to run various applications such as video games and text editors. 
If we phrase problems and tasks into programs, then computers can be seen as zero-shot problem solvers just like LLMs, since most of them are not designed or built for any specific program but as general purpose machines. 
Crucially, computer scientists have developed a host of tools to help understand and further exploit emergent capabilities, such as debuggers, or various high-level programming paradigms.

In this blog, we connect the dots and draw an overlooked connection between these two zero-shot problem solvers, i.e., LLMs and computers.
We believe their similarities outline the potential of using LLMs for a much more general problem solving setting, and their differences help us to understand the behaviors of LLMs and how to improve them.
In particular, we illustrate how a good language model, which allows a concept to be encoded less ambiguously, is at the core of exploiting this new model of computation. 
We hope that this connection will spark new ideas for discussion such as computation theory, security, distributed computing etc. for LLMs.

***


## A Tale of Two Zero-Shot Problem Solvers

In this section, we elaborate on the notion that large language models (LLMs) are zero-shot problem solvers in a similar way in which modern computers are zero-shot problem solvers, since they can both solve much more general problems than those they have been trained or hardcoded for. 
However, we understand much better how such ability emerged in computers than LLMs.
Here, we look into the similarities as well as the differences in the formulations and the histories of both models of computation, and try to understand how LLMs emerged with their abilities.


**Modern Computers** &nbsp;
Computers have undergone several transitions from specialized to universal machines (see [Figure 1(c)](#figure-1)).
As we will discuss [below](#connecting-the-dots), this transition is similar to the recent history of LLMs.
Alan Turing had an early vision<d-cite key="turing1936computable"></d-cite> of a universal computing machine that was way ahead of its time because the real machines around the time were only constructed for special tasks, such as breaking encrypted communication during wartime.
To follow Turing's vision and to avoid building a different machine from scratch for a new task, early computer scientists, built machines with a large collection of different arithmetic units and switches (e.g., ENIAC<d-cite key="weik1961eniac"></d-cite>).
By wiring up these units differently (i.e., programming) and piping the input data through, the machine was able to solve different tasks.
While this made it possible to ''reprogram'' (i.e., rewire) the computer, the program was still part of the hardware wiring, and any changes to it had to be done manually.
The later invention of stored-program computers overcame this limitation and led to even more universal computing machines.
Here, the central idea, expressed in the von Neumann architecture<d-cite key="von1945first"></d-cite>, was to represent programs as data rather than as wiring setups.
This allowed computers to read and solve arbitrary programs for which they were not set up by wiring. In other words, they become zero-shot problem solvers.


**Large Language Models** &nbsp;
Written language can be formed by sequences of tokens. A language model learns mappings to the next token $$t_i$$ from its prefix. 
Such a mapping can be represented as a conditional probability distribution (see [Figure 1(b)](#figure-1)). 
The joint probability of the sequence $$p(\boldsymbol{t})$$ is the product of the conditional probabilities<d-cite key="bengio2000neural"></d-cite>, i.e., 

$$
p(\boldsymbol{t}) = p(t_1)\prod_{i=2}^{N} p(t_i | t_1, \dots, t_{i-1}).
$$

A popular method to model these conditional probabilities is to use Transformers<d-cite key="vaswani2017attention"></d-cite> and train under self-supervision.
With increasing scale of these language models, they turn out to emerge the ability to solve tasks other than language modeling (i.e.,  they are zero-shot problem solvers), and we call them large language models for distinction.

<div class="blog-img-banner l-screen">
  <a name="figure-1"></a>
  <div class="row mt-0">
      <div class="col-sm mt-0 mt-md-0"></div>
      <div class="col-sm-7 mt-0 mt-md-0">
          {% include figure.html path="assets/img/posts_2023-03-10-computers-vs-llms/connects.svg" name="models" class="img-fluid rounded z-depth-0" %}
      </div>
      <div class="col-sm mt-0 mt-md-0"></div>
  </div>
  <div class="row mt-1">
    <div class="col-sm mt-0 mt-md-0"></div>
    <div class="col-sm-6 mt-0 mt-md-0">
      <div class="blog-fig-caption">
        <a class="figure-anchor" style="font-weight: bold;">Figure 1:</a> &nbsp;
        Connections between modern computers and large language models from three different perspectives: 
        (a) they both produce corresponding output after doing computations on the input; 
        (b) they both consist of a compute architecture and a problem translator; 
        (c) they both evolved from a specialized task solver to a general zero-shot problem solver.
      </div>
    </div>
    <div class="col-sm mt-0 mt-md-0"></div>
  </div>
</div>

### Connecting the Dots
Here, we compare the architectures and survey the histories of computers and LLMs, which turned out to be surprisingly similar (see [Figure 1](#figure-1)).
Their likeness might not be a coincidence, and can provide clues for us to understand how LLMs emerge with their abilities.

**Similar frameworks** &nbsp;
Both computers and LLMs can be seen as mappings from $$\mathcal{P}$$ to $$\mathcal{A}$$ ([Figure 1(a)](#figure-1)).
Given a _program_ $$\mathcal{P}$$, a computer will execute $$\mathcal{P}$$ and return the answer $$\mathcal{A}$$ when the program terminates. 
This mapping is deterministic, which means if $$\mathcal{P}$$ is a correct implementation of a suitable algorithm, then $$\mathcal{A}$$ is the correct answer to the problem.
Similarly, given a _prompt_ $$\mathcal{P}$$, an LLM will infer and return an answer $$\mathcal{A}$$.
However, this mapping is stochastic and follows the conditional distribution $$p(\mathcal{A} | \mathcal{P})$$ captured by the LLM.
In addition, the interactive feature of LLMs allows us to easily include previous prompts and answers into the new prompt, i.e., $$\mathcal{P}_i = [\mathcal{P}_{i-1}, \mathcal{A}_{i-1}, new]$$.


**Similar level of abstractions** &nbsp;
Both computers and LLMs consist of a _problem translator_ on top of a foundational _compute architecture_ ([Figure 1(b)](#figure-1)).
The problem translator turns problems written in a human readable language into some native representation of the compute architecture (bit strings for computers, vectors for LLMs).
The compute architecture is formed by a large collection of simple components (logic gates for computers, matrix multiplications and activation functions for LLMs).
In both computers and LLMs, the respective compute architecture is able to do arbitrary computations due to both the scale (i.e., the quantity) and the universality of the involved components.


**Similar histories** &nbsp;
Both computers and LLMs had a similar path of evolution from task-specific to general-purpose problem solvers ([Figure 1(c)](#figure-1)).
Early approaches to NLP designed and trained a model specifically for a given task, e.g., question answering (QA). 
To create more general solutions, people then experimented with model architectures that were trained on a fixed set of tasks, specified by a task identification tag<d-cite key="shazeer2017outrageously,kaiser2017one"></d-cite>.
Similar to the von Neumann architecture of computers, the next important development was to represent the task description in the same format as the input and output, i.e., describing a task in natural language rather than using a special tag<d-cite key="mccann2018natural"></d-cite>.
This resulted in a training objective very similar to language modeling.
Inspired by this, Radford et al.<d-cite key="radford2019language"></d-cite> trained a pure (but very large) language model (i.e., GPT-2) and showed its ability to solve a range of different NLP tasks beyond language modeling.


### Fundamental Difference

Computers and LLMs as zero-shot problem solvers are similar in many ways, but there is one major distinction determined that one cannot be replaced by the other.
LLMs are more accessible for the general public since LLMs understand natural language, but at the same time, natural language is ambiguous and difficult to describe a problem precisely.
Therefore, LLMs might misunderstand what we ask and not able to solve the problem we really want to solve.
In contrast, computers are excellent problem solvers because programming languages are formal language, and we can precisely describe a problem to computers without ambiguity.
However, what we traded off is the accessibility, since users for computers are required to learn these formal languages in order to gain full access to computer's problem solving ability, which is not the case for LLMs.


***


## Lessons to Learn

The connections between computers and LLMs identified [above](#a-tale-of-two-zero-shot-problem-solvers) reveal two important findings about zero-shot problem solvers.
Here, we identify two essential building blocks for them, and we point out a direction to improve LLMs which explains the current focus in the community.

<div class="finding">
  <div class="finding-start">Finding 1</div>
  The zero-shot problem solving ability only emerges when we combine a powerful compute architecture with a suitable problem translator.
</div>
Computational ability is not as rare a property as we might think.
There are many, even simple physical systems that can compute,
but zero-shot problem solving requires an additional layer of abstraction on top of computation that translates new problems into the type of computations that the system can perform.
For example, many problems can be phrased as minimization problems, i.e., finding the lowest point on some surface.
A simple compute architecture capable of solving such an optimization problem could drop a ball onto a physical manifestation of a given surface and record where the ball eventually stops.
While, in principle, many problems can be phrased as such minimization problems, in practice, the problems humans want to solve are typically described in a more readable form.
Without an additional unit that translates the human-readable description into a surface whose lowest point we want to find, the above computation architecture is not capable of zero-shot problem solving.

Both computers and LLMs have very powerful compute architectures, which can be shown to be Turing complete<d-cite key="dehghani2018universal"></d-cite>.
What turns computers and LLMs into zero-shot problem solvers is the fact that they also have powerful problem translators, which map between the native language of the compute architecture and a high-level language, preserving the computation power.


<div class="finding">
  <div class="finding-start">Finding 2</div>
  Minimizing the gap between the language model of LLMs and the internal language model of a user is at the core of unlocking the full problem solving ability of LLMs.
</div>


As we have argued above, ensuring that a solver understands the problem or instruction is key for solving it.
Computers have been excellent problem solvers for the past decades because formal languages are designed to be precise.
This means given a piece of code in some formal language, there is only one correct interpretation (illustrated as a delta distribution in [Figure 2](#figure-2) bottom left) and good programmers are expected to understand the language fairly well (see sharp peak in [Figure 2](#figure-2) top left).
In other words, the models that humans and computers have of a formal language are both relatively _precise_, and the two are closely _aligned_ with each other.
In contrast, natural language is inherently _imprecise_ as there are often many correct interpretations given a sentence.
Moreover, both humans and LLMs learn natural language from data rather than from a specification, so their two models will typically be somewhat _misaligned_ from each other.

<div class="blog-img-body l-body">
  <a name="figure-2"></a>
  <div class="row mt-0">
    <div class="col-sm mt-0 mt-md-0"></div>
    <div class="col-sm-8 mt-0 mt-md-0">
      {% include figure.html path="assets/img/posts_2023-03-10-computers-vs-llms/concept_dists.png" name="concept_dists" class="img-fluid rounded z-depth-0" zoomable=true %}
      <div class="blog-fig-caption">
        <a class="figure-anchor" style="font-weight: bold;">Figure 2:</a> &nbsp;
        Communication gaps between human and the solver with different languages. Language ambiguity is depicted by variance, model misalignment is depicted by the two separate means.
      </div>
    </div>
    <div class="col-sm mt-0 mt-md-0"></div>
  </div>
</div>

Many of the existing works on LLMs as zero-shot problem solvers can be understood as a spectrum of methods for minimizing the communication gap between humans and LLMs.
At one end of the spectrum, we humans can adapt our internal language models towards the language models of LLMs (&#9312; in [Figure 2](#figure-2)), e.g., by incorporating certain signalling phrases into our prompts that empirically improve the quality of answers, such as ''Let's think step by step''<d-cite key="kojima2022large"></d-cite>.
At the other end of the spectrum, we can adapt LLMs towards our internal language models (&#9313; in [Figure 2](#figure-2)).
This can be done during training (e.g., as in InstructGPT and ChatGPT, which were trained with human feedback<d-cite key="ouyang2022training"></d-cite>), or after training (e.g., personalizing the model by few-shot prompting, i.e., prefixing prompts with examples of similar problems and their solutions or with a conversation history).
Most prompting research falls somewhere in between these two extremes, where humans and LLMs adapt their models towards each other (&#9314; in [Figure 2](#figure-2))<d-cite key="liu2021pre"></d-cite>.
