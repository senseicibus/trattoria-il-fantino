/** Self-host build config for Trattoria il Fantino.
 *  Mirrors the inline tailwind.config that used to live in index.html.
 *  Run: npx tailwindcss -i tailwind.input.css -o tailwind.css --minify */
module.exports = {
  content: ['./index.html', './privacy.html'],
  theme: { extend: {
    colors: {
      linen:{DEFAULT:'#F7F2E8', surface:'#EDE6D6', raised:'#E3DAC8'},
      forest:{DEFAULT:'#1C3530'},
      teal:{DEFAULT:'#2E6F66', soft:'#3E8A7E'},
      gold:{DEFAULT:'#D8A24A', soft:'#E7C07A'},
      golddark:'#A07820',
      cream:'#F4EFE3',
      line:'rgba(46,111,102,.18)',
    },
    fontFamily:{ display:['Fraunces','Georgia','serif'], body:['"Hanken Grotesk"','system-ui','sans-serif'] },
    maxWidth:{ content:'78rem' },
  } },
};
