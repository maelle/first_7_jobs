Analyzing \#first7jobs tweets with Monkeylearn and R
====================================================

In this repo I store the code I used for preparing [this blog post for
Monkeylearn](https://blog.monkeylearn.com/analyzing-first7jobs-tweets-monkeylearn-r/).

I used \#first7jobs tweets as example of text analysis in R, starting
from querying Twitter API with the rtweet package, then cleaning the
tweets a bit, and then using the monkeylearn package to classify the
jobs in an industry.

I have divided the code into several scripts, hopefully you and older-I
will find that easy to navigate (at least it works when I re-read my
[India trains repo](https://github.com/masalmon/india_trains)). The
scripts are:

-   [Getting the tweets](code/get_data.R) which I did with
    [rtweet](https://github.com/mkearney/rtweet).

-   [Parsing the tweets](code/parse_tweets.R) which was made easier by
    [stringr](https://github.com/hadley/stringr) and
    [dplyr](https://github.com/hadley/dplyr).

-   [Finding the industries for job descriptions in
    tweets](code/find_industries.R) which I did using my own
    [monkeylearn package](https://github.com/ropenscilabs/monkeylearn),
    and dplyr again.

-   [Finding the keywords by
    industry](code/find_keywords_by_industry.R), with monkeylearn and
    dplyr again.

-   The visualization code itself is in the [Rmd of the post](post.Rmd).
    I used [ggplot2](https://github.com/hadley/ggplot2) for the numerous
    barplots, [viridis](https://github.com/sjmgarnier/viridis) for nice
    color scales, and [circlize](https://github.com/jokergoo/circlize)
    for the circle plot.
