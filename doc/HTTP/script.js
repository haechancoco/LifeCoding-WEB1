const tocList = document.getElementById('toc-list');
const headers = document.querySelectorAll('h2');

headers.forEach((header, index) => {
    if (!header.id) {
        header.id = 'section-' + index;
    }

    const li = document.createElement('li');
    const a = document.createElement('a');

    a.href = '#' + header.id;
    a.innerText = header.innerText;

    li.appendChild(a);
    tocList.appendChild(li);
});