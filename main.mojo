from python import Python
from time import now
from extractor.extract import PDFImageExtractor, PDFPageToImageConverter, PDFTextExtractor

fn main() raises:
    try:
        var timestamp = str(now())
        print("Starting PDF processing at ", timestamp)

        var args = Python.import_module("sys").argv
        var default_path = "./extract/target.pdf"
        var pdf_path: String

        if len(args) > 1:
            pdf_path = str(args[1])
        else:
            pdf_path = default_path

        print("Processing:", pdf_path)

        var image_extractor = PDFImageExtractor()
        var page_converter = PDFPageToImageConverter()
        var text_extractor = PDFTextExtractor()

        var extract_count = image_extractor.extract_images(pdf_path)
        var convert_count = page_converter.convert_pages(pdf_path)
        var text_file_count = text_extractor.extract_text(pdf_path)

        print("\nExtracted", extract_count, "images")
        image_extractor.print_extracted_files()

        print("\nConverted", convert_count, "pages")
        page_converter.print_converted_files()

        print("\nCreated", text_file_count, "text files")
        text_extractor.print_extracted_files()

        print("\nProcessing complete!")
    except:
        print("Error processing PDF. Please check the file exists and is readable.")
