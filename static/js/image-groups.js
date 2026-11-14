(() => {
  const containers = document.querySelectorAll(
    ".topic-introduction, .post-content-blocks"
  );

  for (const container of containers) {
    for (const paragraph of container.querySelectorAll(":scope > p")) {
      const image = paragraph.querySelector(":scope > img.content-image");
      if (!image || paragraph.textContent.trim()) continue;

      const figure = document.createElement("figure");
      figure.className = "image-block";
      figure.append(image);

      const caption = image.getAttribute("title");
      image.removeAttribute("title");
      if (caption) {
        figure.classList.add("image-block--captioned");
        const figcaption = document.createElement("figcaption");
        figcaption.textContent = caption;
        figure.append(figcaption);
      } else {
        figure.classList.add("image-block--uncaptioned");
      }

      paragraph.replaceWith(figure);
    }

    let node = container.firstElementChild;
    while (node) {
      if (!node.matches("figure.image-block")) {
        node = node.nextElementSibling;
        continue;
      }

      const captioned = node.classList.contains("image-block--captioned");
      const run = [node];
      let next = node.nextElementSibling;
      while (
        next &&
        next.matches("figure.image-block") &&
        next.classList.contains("image-block--captioned") === captioned
      ) {
        run.push(next);
        next = next.nextElementSibling;
      }

      if (run.length > 1) {
        const gallery = document.createElement("div");
        gallery.className = `topic-image-gallery topic-image-gallery--${
          captioned ? "columns" : "compact"
        }`;
        container.insertBefore(gallery, run[0]);
        for (const figure of run) gallery.append(figure);
      }

      node = next;
    }
  }
})();
