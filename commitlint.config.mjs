export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'build',
        'chore',
        'ci',
        'docs',
        'feat',
        'fix',
        'perf',
        'planning',
        'refactor',
        'revert',
        'style',
        'test',
      ],
    ],
    'subject-case': [2, 'never', ['upper-case']],
  },
  helpUrl: 'https://www.conventionalcommits.org/en/v1.0.0/',
};
