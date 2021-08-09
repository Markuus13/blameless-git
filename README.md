# Blameless Git

This is a side project mainly created to practice some software development techniques. It means that exists simpler ways of solving the problem that this app solves, but stills worth to make things the way I did so I can practice some concepts.

This application should provide an obfuscated interface of a public git repository from known providers such as github, gitlab and bitbucket. That obfuscated interface should not reveal the author of the original repository, which may be useful for avoiding bias in interview exercises.

### Status:
[![CircleCI](https://circleci.com/gh/Markuus13/blameless-git/tree/main.svg?style=svg)](https://circleci.com/gh/Markuus13/blameless-git/tree/main) [![codecov](https://codecov.io/gh/Markuus13/blameless-git/branch/main/graph/badge.svg?token=690B2KMERZ)](https://codecov.io/gh/Markuus13/blameless-git)

### Development requirements

- Ruby 3.0.1
- Bundler

### Testing

To run all tests:

`bundle exec rspec`
