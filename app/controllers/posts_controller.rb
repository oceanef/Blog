class PostsController < ApplicationController

	def index
	#Start the count before the action of rendering the index page
		start_time = Time.now
		@posts = Post.all.order('created_at DESC')
	#After the action, calculate the timeslot with the duration variable
		duration = Time.now - start_time
		tags = "page:index"
	#Add the histogram of the new metrics 'blob.latency'. We keep the same tag to well identify the page view
		$statsd.histogram('blog.latency', duration, :tags => [tags])
		$statsd.increment('blog.page.views', :tags => [tags])
	end

	def new
		@post = Post.new
	#Every-time the authorized user wants to create a new post, statsd increments the count and sends it to Datadog
	#Here the metrics refers to a new post view, tag refers to the initial creation of a post
			tags = "post:creation"
			$statsd.increment('blog.page.views', :tags => [tags])
	end

	def create
		@post = Post.new(post_params)
		if @post.save
			redirect_to @post
		else 
			render 'new'
	#Every-time someone fails to create a new post, statsd increments the count and sends it to Datadog
	#Here the metrics refers to a post creation failure, tag refers to the initial creation of a post
			tags = "post:creation"
			$statsd.increment('blog.failed.post', :tags => [tags])

		end
	end

	def show
		start_time = Time.now
		@post = Post.find(params[:id])
		duration = Time.now - start_time
		tags = "page:#{@post.title}"
		$statsd.histogram('blog.latency', duration, :tags => [tags])
		$statsd.increment('blog.page.views', :tags => [tags])
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post =  Post.find(params[:id])

		if @post.update(params[:post].permit(:title, :body, :image))
			redirect_to @post
		else
			render 'edit'
	#Every-time someone fails to create a new post, statsd increments the count and sends it to Datadog
	#Here the metrics refers to a post creation failure, tags refers to the update of a post
			tags = "post:update"
			$statsd.increment('blog.failed.post', :tags => [tags])
		end
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy

		redirect_to root_path 
	end

	private

	def post_params
		params.require(:post).permit(:title, :body, :image)
	end
end
