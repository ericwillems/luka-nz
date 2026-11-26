(() => {
  const dialog = document.querySelector(".card-image-viewer");
  if (!(dialog instanceof HTMLDialogElement) || typeof dialog.showModal !== "function") {
    return;
  }

  const triggers = [...document.querySelectorAll(".card-image-trigger")];
  if (triggers.length === 0) return;

  const image = dialog.querySelector(".card-image-viewer__image");
  const caption = dialog.querySelector(".card-image-viewer__caption");
  const closeButton = dialog.querySelector(".card-image-viewer__close");
  const previousButton = dialog.querySelector(".card-image-viewer__previous");
  const nextButton = dialog.querySelector(".card-image-viewer__next");
  let currentIndex = 0;

  const showImage = (index) => {
    currentIndex = (index + triggers.length) % triggers.length;
    const trigger = triggers[currentIndex];
    const source = trigger.querySelector("img");

    image.src = source.currentSrc || source.src;
    image.alt = source.alt;
    caption.textContent = `${trigger.dataset.cardTitle} — ${currentIndex + 1} of ${triggers.length}`;
  };

  triggers.forEach((trigger, index) => {
    trigger.addEventListener("click", () => {
      showImage(index);
      dialog.showModal();
      closeButton.focus();
    });
  });

  previousButton.addEventListener("click", () => showImage(currentIndex - 1));
  nextButton.addEventListener("click", () => showImage(currentIndex + 1));
  closeButton.addEventListener("click", () => dialog.close());

  dialog.addEventListener("click", (event) => {
    if (event.target === dialog) dialog.close();
  });

  document.addEventListener("keydown", (event) => {
    if (!dialog.open) return;

    if (event.key === "Escape") {
      event.preventDefault();
      dialog.close();
    } else if (event.key === "ArrowLeft") {
      event.preventDefault();
      showImage(currentIndex - 1);
    } else if (event.key === "ArrowRight") {
      event.preventDefault();
      showImage(currentIndex + 1);
    }
  });
})();
