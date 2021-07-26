# Название .ZIP-файла, содержащего собранный датапак.
name   = Armor Statues 2.9.2-RU-0.0.1

# Каталог, где будет создан ZIP-файл датапака.
outdir = build


.PHONY: build lint lint_json package format format_json copy_og_trans


build: lint package


lint: lint_json


lint_json:
	@find																																																																																			\
		-type f -iname "*.json"																																																																									\
	! -path "./reference/minecraft/*"																																																																					\
		-print0																																																																																	\
	| while IFS= read -d "" file; do																																																																					\
		printf "%s" "$$(file="$${file#./data/}"; echo "$${file%.json}")"																																						 													 ;\
		err="$$(jq "" "$$file" 2>&1 >/dev/null)"																	 																																												 	 	 ;\
		if [ "$$?" -ne 0 ]; then																	 								 																																												  		\
			printf "%s\n" " - ОШИБКА"																								 																																												 	 	 ;\
			printf "%s: %s\n" "$$file" "$$err"																			 																																												 	 	 ;\
			exit 1																																	 																																												 	 	 ;\
		else																																			 																																															\
			printf "%s\n" " - OK"																										 																																												 	 	 ;\
		fi				 																																 																																												 	 	 ;\
	done												 																																												 	 	 																								 ;\


package:
	@mkdir -p "$(outdir)/datapacks"																												 																																									 ;\
	find																																																																																			\
		-type f																																																																																	\
	! \(																																																																																			\
			-path "./.git/*" -o																																																																										\
			-path "./reference/*" -o																																																																							\
			-path "./Makefile" -o																																																																									\
			-path "./.gitignore" -o																																																																								\
			-path "./.gitlab-ci.yml"																																																																							\
		\) 																																																																																			\
	| zip "$(outdir)/datapacks/$(name).zip" -@


format: format_json


format_json:
	@find																																																																																 			\
		-type f -iname "*.json"																																																																						 			\
	! -path "./reference/minecraft/*"																																																																		 			\
		-print0																																																																														 			\
	| while IFS= read -d "" file; do																																																																		 			\
		printf "%s" "$$(file="$${file#./data/}"; echo "$${file%.json}")"																																						 													 ;\
		err="$$(jq . "$$file" 2>&1 >"$$file~")"																		 																																												 	 	 ;\
		if [ "$$?" -ne 0 ]; then																	 								 																																												  		\
			printf "%s\n" " - ОШИБКА"																								 																																												 	 	 ;\
			printf "%s: %s\n" "$$file" "$$err"																			 																																												 	 	 ;\
			rm "$$file~"																														 																																												 	 	 ;\
			exit 1																																	 																																												 	 	 ;\
		else																																			 																																												 			\
			mv "$$file~" "$$file"																										 																																												 	 	 ;\
			printf "%s\n" " - OK"																										 																																												 	 	 ;\
		fi				 																																 																																												 	 	 ;\
	done
